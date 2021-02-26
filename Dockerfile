FROM node:10

ENV SECRET_WORD="TwelveFactor"

COPY /quest .

RUN npm install 

EXPOSE 3000

ENTRYPOINT ["npm", "start"]    
