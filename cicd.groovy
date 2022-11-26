node('linux')
{
  stage('Build') {
    build job: 'Port-Pipeline', parameters: [string(name: 'PORT_GITHUB_REPO', value: 'https://github.com/ZOSOpenTools/gnulibport.git'), string(name: 'PORT_DESCRIPTION', value: 'Gnulib is a central location for common GNU code, intended to be shared among GNU packages.' )]
  }
}
