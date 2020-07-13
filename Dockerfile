FROM docker:19

ENV KUBECTL_VERSION=v1.18.2
ENV HELM_FILENAME=helm-v3.1.2-linux-amd64.tar.gz
ENV HELM_DOWNLOAD_URL=https://get.helm.sh/${HELM_FILENAME}

ENV GRADLE_FILE=gradle-6.5.1-bin.zip
ENV GRADLE_INSTALL_DIR=/opt/gradle

RUN apk update && \
    apk upgrade && \
    apk add zip unzip && \
    apk --no-cache add openjdk11 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community && \
    mkdir $GRADLE_INSTALL_DIR && \
    wget -q -O "$GRADLE_INSTALL_DIR/$GRADLE_FILE" "https://services.gradle.org/distributions/$GRADLE_FILE" && \
    unzip -d $GRADLE_INSTALL_DIR $GRADLE_INSTALL_DIR/$GRADLE_FILE && \
    export PATH=$PATH:$GRADLE_INSTALL_DIR/gradle-6.5.1/bin && \
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
