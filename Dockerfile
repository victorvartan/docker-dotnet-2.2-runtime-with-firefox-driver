# docker image build -t victorvartan/dotnet-2.2-runtime-with-firefox-driver:latest .

FROM microsoft/dotnet:2.2-runtime

# Install Firefox
RUN apt-get update -qqy \
  && apt-get -qqy install \
    firefox-esr \
	--no-install-recommends \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*
  
# Download GeckoDriver
ARG GECKODRIVER_VERSION=latest
RUN GK_VERSION=$(if [ ${GECKODRIVER_VERSION:-latest} = "latest" ]; then echo "0.24.0"; else echo $GECKODRIVER_VERSION; fi) \
  && echo "Using GeckoDriver version: "$GK_VERSION \
  && curl -s -L -G https://github.com/mozilla/geckodriver/releases/download/v$GK_VERSION/geckodriver-v$GK_VERSION-linux64.tar.gz -o /tmp/geckodriver.tar.gz \
  && rm -rf /opt/geckodriver \
  && tar -C /opt -zxf /tmp/geckodriver.tar.gz \
  && rm /tmp/geckodriver.tar.gz \
  && chmod 755 /opt/geckodriver

# Cleanup
RUN rm -rf /tmp/*.* \
&& apt-get purge -y --auto-remove curl