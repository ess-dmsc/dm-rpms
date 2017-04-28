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

    stage('Checkout') {
        checkout scm
    }

    stage('Build') {
        sh "make && make mostlyclean"
        stash includes: 'rpms/**/*.rpm', name: 'rpms'
    }
}

node('yum-repo') {
    stage('Unstash') {
        unstash 'rpms'
    }

    stage('Create Repo') {
        sh "createrepo rpms"
    }

    stage('Archive') {
        archiveArtifacts artifacts: 'rpms/', fingerprint: true, onlyIfSuccessful: true
    }
}
