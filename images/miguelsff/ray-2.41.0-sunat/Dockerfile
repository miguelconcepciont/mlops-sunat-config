FROM rayproject/ray:2.41.0-py311

COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt
RUN rm requirements.txt