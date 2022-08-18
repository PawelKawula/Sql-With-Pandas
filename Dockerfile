FROM amancevice/pandas:alpine
WORKDIR /app

COPY src ./src
COPY uuid.so ./uuid.so
COPY .sqliterc /root/.sqliterc

RUN apk add sqlite libuuid
RUN src/main.py

#COPY requirements.txt ./
#RUN pip --user install --no-cache-dir -r requirements.txt

#CMD [ "python", "./your-daemon-or-script.py" ]
