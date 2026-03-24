import pytest
from playwright.async_api import async_playwright


@pytest.mark.asyncio(loop_scope="session")
async def test_chromium_async_basic_navigation() -> None:
    """Smoke test: open Chromium asynchronously and verify page title."""
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=False)
        page = await browser.new_page()
        await page.goto("https://playwright.dev/python/")
        await page.pause()
