//Basic App for deploying to App Service in Azure
const express = require('express');
const app = express();
const port = process.env.PORT || 80;
const os = require('os');

const hostname = os.hostname();

app.get('/', (req, res) => {
  res.send('AZURE APP SERVICE - Node.js App is running!');
});

app.listen(port, () => {
  console.log(`Server is running on http://${hostname}:${port}`);
});

