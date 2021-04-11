(function () {
	let inputText, inputHidden, dropdown, dropdownContent;

	function clearHiddenValue() {
		inputHidden.value = "";
	}

	function activateDropdown() {
		dropdown.classList.add("is-active");
	}

	function deactivateDropdown() {
		dropdown.classList.remove("is-active");
	}

	function createDropDownItem(child) {
		const ddItem = document.createElement("div");
		ddItem.classList.add("dropdown-item");

		ddItem.appendChild(child);
		return ddItem;
	}

	function handleDropdownMenuItemClick(evt) {
		inputText.value = evt.target.innerText;
		inputHidden.value = evt.target.dataset.item_id;

		deactivateDropdown();
	}

	function addDropdownMessage() {
		const textEl = document.createElement("p");
		textEl.innerText = "Nothing to display.";
		textEl.classList.add("has-text-centered", "is-italic");
		textEl.addEventListener("click", deactivateDropdown);

		dropdownContent.appendChild(createDropDownItem(textEl));
	}

	function clearDropdownMenu() {
		while (dropdownContent.firstChild) {
			dropdownContent.removeChild(dropdownContent.firstChild);
		}
	}

	function populateDropdownMenu(items) {
		clearDropdownMenu();

		if (items.length === 0) {
			addDropdownMessage();
			clearHiddenValue();

			return;
		}

		items.forEach(function (item) {
			const button = document.createElement("button");
			button.innerText = `${item.abbreviation} ${item.name}`;
			button.type =
				inputText.dataset.autoSubmit === "true" ? "submit" : "button";
			button.dataset.item_id = item.id;
			button.classList.add("button", "is-inverted", "dropdown-item");
			button.addEventListener("click", handleDropdownMenuItemClick);

			dropdownContent.appendChild(button);
		});

		activateDropdown();
	}

	document.addEventListener("turbolinks:load", function () {
		inputText = document.getElementById("item_dropdown_input");

		if (!inputText) {
			return;
		}

		dropdown = document.getElementById("item_dropdown");
		dropdownContent = document.getElementById("item_dropdown_content");
		inputHidden = dropdown.querySelector("input[type=hidden]");

		let queryTimeoutId;

		inputText.addEventListener("keyup", function (evt) {
			const target = evt.target;

			if (evt.shiftKey || evt.ctrlKey || evt.altKey || evt.metaKey) {
				return;
			}

			if (queryTimeoutId) {
				clearTimeout(queryTimeoutId);
			}

			if (target.value.trim().length === 0) {
				clearDropdownMenu();
				addDropdownMessage();
				clearHiddenValue();

				return;
			}

			queryTimeoutId = setTimeout(function () {
				const url = new URL("/items", window.location.origin);
				url.search = new URLSearchParams({ query: target.value }).toString();

				fetch(url)
					.then(response => response.json())
					.then(data => populateDropdownMenu(data));
			}, 500);
		});
	});
})();
