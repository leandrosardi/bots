# Reference:
# - https://skolo.online/documents/webscrapping/#step-1-download-chrome
# - https://stackoverflow.com/questions/50642308/webdriverexception-unk
#
sudo apt update
wget http://mirror.cs.uchicago.edu/google-chrome/pool/main/g/google-chrome-stable/google-chrome-stable_114.0.5735.90-1_amd64.deb
sudo dpkg -i google-chrome-stable_114.0.5735.90-1_amd64.deb
sudo apt-get install -f
google-chrome --version