pipeline {
    agent any
 
    environment {
        DB_SERVER = "10.179.10.49"
        DB_NAME   = "gemOffice"
    }
 
    stages {
        stage('Run DB Scripts') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'sql-db-creds',
                        usernameVariable: 'DB_USER',
                        passwordVariable: 'DB_PASS'
                    )
                ]) {
 
                    script {
 
                        // Folders to scan
                        def scriptFolders = [
                            "DBScripts/Tables",
                            "DBScripts/StoredProcedures"
                        ]
 
                        scriptFolders.each { folder ->
 
                            // Find SQL files inside the folder
                            def files = findFiles(glob: "${folder}/*.sql")
 
                            files.each { file ->
                                def scriptName = file.name
 
                                echo "Checking script: ${scriptName}"
 
                                // ---- Step 1: Check execution history ----
                                def checkCmd = """
                                    sqlcmd -S ${DB_SERVER} -d ${DB_NAME} -U %DB_USER% -P %DB_PASS% -Q "SET NOCOUNT ON; SELECT COUNT(*) FROM dbo.ScriptExecutionHistory WHERE ScriptName='${scriptName}'"
                                """
 
                                def output = bat(script: checkCmd, returnStdout: true).trim()
 
                                // Extract last numeric value (sqlcmd adds extra header text)
                                def count = output.replaceAll(/(?s).*?(\d+)$/, "\$1")
 
                                if (count == "0") {
                                    echo "Executing script: ${scriptName}"
 
                                    // ---- Step 2: Execute SQL file ----
                                    bat """
                                        sqlcmd -S ${DB_SERVER} -d ${DB_NAME} -U %DB_USER% -P %DB_PASS% -i "${file.path}"
                                    """
 
                                    // ---- Step 3: Insert execution history ----
                                    bat """
                                        sqlcmd -S ${DB_SERVER} -d ${DB_NAME} -U %DB_USER% -P %DB_PASS% -Q "INSERT INTO dbo.ScriptExecutionHistory (ScriptName, Status) VALUES ('${scriptName}', 'Success')"
                                    """
 
                                    echo "Inserted history for: ${scriptName}"
 
                                } else {
                                    echo "Skipping: ${scriptName} (already executed)"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
