pipeline {
    agent any
 
    environment {
        DB_SERVER = "10.179.10.49"          // e.g. localhost,1433
        DB_NAME   = "gemOffice"            // e.g. EmployeeDB
    }
 
    stages {
 
        stage('Run DB Scripts') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'sql-db-creds',
                                                usernameVariable: 'DB_USER',
                                                passwordVariable: 'DB_PASS')]) {
 
                    script {
                        def scriptFolders = ["DBScripts/Tables", "DBScripts/StoredProcedures"]
 
                        scriptFolders.each { folder ->
                            def files = findFiles(glob: "**/*.sql")
 
                            files.each { file ->
 
                                def scriptName = file.name
 
                                echo "Checking script: ${scriptName}"
 
                                // Check if script executed already
                                def checkCmd = """
                                    sqlcmd -S ${DB_SERVER} -d ${DB_NAME} -U ${DB_USER} -P ${DB_PASS} \
                                    -Q "SELECT COUNT(*) FROM dbo.ScriptExecutionHistory WHERE ScriptName='${scriptName}'"
                                """
 
                                def result = bat(script: checkCmd, returnStdout: true).trim()
 
                                if (result.endsWith("0")) {
 
                                    echo "Executing script: ${scriptName}"
 
                                    // Execute SQL script
                                    bat """
                                        sqlcmd -S ${DB_SERVER} -d ${DB_NAME} -U ${DB_USER} -P ${DB_PASS} -i "${file.path}"
                                    """
 
                                    // Insert into history table
                                    bat """
                                        sqlcmd -S ${DB_SERVER} -d ${DB_NAME} -U ${DB_USER} -P ${DB_PASS} \
                                        -Q "INSERT INTO dbo.ScriptExecutionHistory (ScriptName, Status) VALUES ('${scriptName}', 'Success')"
                                    """
 
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
