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
    }

    stage('Archive') {
        archiveArtifacts artifacts: 'rpms/**/*.rpm', fingerprint: true, onlyIfSuccessful: true
    }
}
