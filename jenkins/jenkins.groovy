pipeline {
    agent any
    parameters {
        choice(
            name: 'OS', 
            choices: ['linux', 'darwin', 'windows'], 
            description: 'Target operating system'
        )
        choice(
            name: 'ARCH', 
            choices: ['amd64', 'arm64'], 
            description: 'Target architecture'
        )
        booleanParam(
            name: 'SKIP_TESTS', 
            defaultValue: false, 
            description: 'Skip running tests'
        )
        booleanParam(
            name: 'SKIP_LINT', 
            defaultValue: false, 
            description: 'Skip running linter'
        )
    }
    stages {
        stage('Show parameters') {
            steps {
                echo "OS = ${params.OS}"
                echo "ARCH = ${params.ARCH}"
                echo "SKIP_TESTS = ${params.SKIP_TESTS}"
                echo "SKIP_LINT = ${params.SKIP_LINT}"
            }
        }
    }
}
