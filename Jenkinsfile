def failure_function(exception_obj, failureMessage) {
    def toEmails = [[$class: 'DevelopersRecipientProvider']]
    emailext body: '${DEFAULT_CONTENT}\n\"' + failureMessage + '\"\n\nCheck console output at $BUILD_URL to view the results.', recipientProviders: toEmails, subject: '${DEFAULT_SUBJECT}'
    throw exception_obj
}

node('rpm-packager') {
    // Set number of old builds to keep.
    properties([[
        $class: 'BuildDiscarderProperty',
        strategy: [
            $class: 'LogRotator',
            artifactDaysToKeepStr: '',
            artifactNumToKeepStr: '1',
            daysToKeepStr: '',
            numToKeepStr: ''
        ]
    ]]);
    
    try {
        stage('Checkout') {
            checkout scm
        }
    } catch (e) {
        failure_function(e, 'Checkout failed')
    }
    
    try {
        stage('Build') {
            sh "make && make mostlyclean"
            stash includes: 'rpms/**/*.rpm', name: 'rpms'
        }
    } catch (e) {
        failure_function(e, 'Build failed')
    }
}

node('yum-repo') {
    try {
        stage('Unstash') {
            unstash 'rpms'
        }
    } catch (e) {
        failure_function(e, 'Unstash failed')
    }
    
    try {
        stage('Create Repo') {
            sh "createrepo rpms"
        }
    } catch (e) {
        failure_function(e, 'Create repo failed')
    }
    
    try {
        stage('Archive') {
            archiveArtifacts artifacts: 'rpms/', fingerprint: true, onlyIfSuccessful: true
        }
    } catch (e) {
        failure_function(e, 'Archive failed')
    }
}
