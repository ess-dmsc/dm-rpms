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

    stage 'Checkout'
    checkout scm

    stage 'Build'
    sh "cd dm-rpms && \
        make && \
        make mostlyclean"
    step([$class: 'ClaimPublisher']) // Allow broken build claiming.

    stage 'Archive'
    archiveArtifacts
        artifacts: 'dm-rpms/rpms/**/*.rpm',
        fingerprint: true,
        onlyIfSuccessful: true
}
