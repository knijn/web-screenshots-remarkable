FROM ubuntu
RUN apt update
RUN apt install -y python3 python3-pip lua5.4 wget imagemagick

# Now its time for the fun game of "LETS INSTALL CHROME WOOOOOOOOOO"
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get -y update
RUN apt-get install -y google-chrome-stable
RUN apt-get install -yqq unzip
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/114.0.5735.90/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

# Now we install NodeJS
RUN wget https://deb.nodesource.com/setup_18.x -O nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install -y nodejs

# For some reason imagemagick disallows converting to pdf so here's a fix for that
RUN sed -i 's/rights="none" pattern="PDF"/rights="read|write" pattern="PDF"/' /etc/ImageMagick-6/policy.xml

# Throw rmapi in there too for good measure
RUN wget https://github.com/juruen/rmapi/releases/download/v0.0.25/rmapi-linuxx86-64.tar.gz
RUN tar -xvf rmapi-linuxx86-64.tar.gz
RUN mv rmapi /usr/local/bin/
RUN chmod +x /usr/local/bin/rmapi

# and we actually need to install the app to run it
RUN mkdir /app
COPY . /app
WORKDIR /app
#RUN mkdir /app/tmp
RUN pip install -r requirements.txt
RUN npm install
RUN npx puppeteer browsers install chrome


CMD ["lua", "main.lua"]