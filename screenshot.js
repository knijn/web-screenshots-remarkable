const puppeteer = require('puppeteer');

process.argv.forEach(function (val, index, array) {
    console.log(index + ': ' + val);
  });

(async () => {

  const browser = await puppeteer.launch({
    args: ['--no-sandbox', '--disable-setuid-sandbox'], // this totally wont bite me in my back again in the future
  });
  const page = await browser.newPage();

  // Set the viewport's width and height
  await page.setViewport({ width: 936, height: 702 });

  // Open page
  await page.goto(process.argv[2]);

  try {
    // Capture screenshot and save it in the tmp folder
    await page.screenshot({ path: `${process.argv[3]}`, fullPage: true});

  } catch (err) {
    console.log(`Error: ${err.message}`);
  } finally {
    await browser.close();
    console.log(`Screenshot has been captured successfully`);
  }
})();