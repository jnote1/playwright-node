import pytest
from playwright.async_api import async_playwright


@pytest.mark.asyncio
async def test_chromium_async_basic_navigation() -> None:
    """
    Automated test: open Chromium asynchronously and verify page load.
    This test runs in CI without manual intervention (headless mode).
    """
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        page = await browser.new_page()
        
        try:
            await page.goto("https://playwright.dev/python/", wait_until="domcontentloaded")
            
            # Automatic validation
            title = await page.title()
            assert "Playwright" in title, f"Expected 'Playwright' in title, got: {title}"
            
            # Check that main content is present
            content = await page.content()
            assert len(content) > 0, "Page content should not be empty"
            
        finally:
            await browser.close()
