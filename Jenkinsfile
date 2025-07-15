pipeline {
  agent any                    // Tourne sur le nœud par défaut

  environment {
    REGISTRY   = 'camara/mon-site'   // change selon ton Docker Hub ou GHCR
  }

  stages {

    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build image') {
      steps {
        sh """
          docker build -t $REGISTRY:${BUILD_NUMBER} .
          docker tag  $REGISTRY:${BUILD_NUMBER} $REGISTRY:latest
        """
      }
    }

    stage('Push image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'docker-creds',
                          usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          sh 'echo $PASS | docker login -u $USER --password-stdin'
        }
        sh 'docker push $REGISTRY:${BUILD_NUMBER}'
        sh 'docker push $REGISTRY:latest'
      }
    }

    stage('Deploy (prod)') {
      when { branch 'main' }
      steps {
        sshagent(['ssh-prod']) {
          sh """
            ssh myuser@vps 'docker pull $REGISTRY:latest &&
                            docker stop site || true &&
                            docker rm   site || true &&
                            docker run -d --name site -p 80:80 $REGISTRY:latest'
          """
        }
      }
    }
  }
}
