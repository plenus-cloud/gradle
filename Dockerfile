FROM docker:19

RUN apk update && \
    apk upgrade && \
    apk add zip unzip && \
    apk --no-cache add openjdk11 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community && \
    mkdir /opt/gradle && \
    wget -q -O "/opt/gradle/gradle-6.5.1-bin.zip" "https://services.gradle.org/distributions/gradle-6.5.1-bin.zip" && \
    unzip -d /opt/gradle /opt/gradle/gradle-6.5.1-bin.zip && \
    export PATH=$PATH:/opt/gradle/gradle-6.5.1/bin && \
    export HELM_TMP_ROOT="$(mktemp -dt helm-installer-XXXXXX)" && \
    export HELM_TMP_FILE="$HELM_TMP_ROOT/$HELM_FILENAME" && \
    echo ${HELM_TMP_FILE} && \
    echo ${HELM_DOWNLOAD_URL} && \
    wget -q -O "${HELM_TMP_FILE}" "${HELM_DOWNLOAD_URL}" && \
    mkdir helm && \
    tar xf ${HELM_TMP_FILE} -C ./helm && \
    mv helm/linux-amd64/helm /usr/local/bin/ && \
    rm -rf ./helm && \
    wget -q -O "./kubectl" "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl
