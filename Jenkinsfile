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
 
                        // FIXED FOLDER PATHS
                        def scriptFolders = ["Tables", "StoredProcedures"]
 
                        scriptFolders.each { folder ->
 
                            echo "Looking for SQL files in: ${folder}"
 
                            def files = findFiles(glob: "${folder}/*.sql")
 
                            if (files.size() == 0) {
                                echo "❗ No SQL files found in ${folder}"
                            }
 
                            files.each { file ->
 
                                def scriptName = file.name
                                echo "Checking script: ${scriptName}"
 
                                def checkCmd = """
                                    sqlcmd -S ${DB_SERVER} -d ${DB_NAME} -U %DB_USER% -P %DB_PASS% \
                                    -Q "SET NOCOUNT ON; SELECT COUNT(*) FROM dbo.ScriptExecutionHistory WHERE ScriptName='${scriptName}'"
                                """
 
                                def output = bat(script: checkCmd, returnStdout: true).trim()
                                def count = output.replaceAll(/(?s).*?(\d+)$/, "\$1")
 
                                if (count == "0") {
 
                                    echo "Executing: ${scriptName}"
 
                                    bat """
                                        sqlcmd -S ${DB_SERVER} -d ${DB_NAME} -U %DB_USER% -P %DB_PASS% -i "${file.path}"
                                    """
 
                                    bat """
                                        sqlcmd -S ${DB_SERVER} -d ${DB_NAME} -U %DB_USER% -P %DB_PASS% \
                                        -Q "INSERT INTO dbo.ScriptExecutionHistory (ScriptName, Status) VALUES ('${scriptName}', 'Success')"
                                    """
 
                                } else {
                                    echo "Skipping: ${scriptName} (Already Executed)"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
