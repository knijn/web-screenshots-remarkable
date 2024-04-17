import asyncio
import nodriver as uc
import sys

async def main():
    browser = await uc.start(
        headless=True,
        no_sandbox=True, # this is bound to break in the future
    )
    page = await browser.get(sys.argv[1])
    print("Opened page, waiting for " + sys.argv[3] + " seconds")
    await page.sleep(float(sys.argv[3]))
    print("Taking screenshot")
    await page.save_screenshot(full_page=True, format='png', filename="/app/tmp/" + sys.argv[2])
    
if __name__ == '__main__':

    # since asyncio.run never worked (for me)
    uc.loop().run_until_complete(main())