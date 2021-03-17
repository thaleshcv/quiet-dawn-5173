(function () {
	let inputText, inputHidden, dropdownMenu;

	function clearHiddenValue() {
		inputHidden.value = "";
	}

	function handleDropdownMenuItemClick(evt) {
		inputText.value = evt.target.innerText;
		inputHidden.value = evt.target.dataset.asset_id;
	}

	function addDropdownMessage() {
		const textEl = document.createElement("p");
		textEl.innerText = "Nothing to display.";
		textEl.classList.add("text-center", "text-muted", "font-italic");

		dropdownMenu.appendChild(textEl);
	}

	function clearDropdownMenu() {
		while (dropdownMenu.firstChild) {
			dropdownMenu.removeChild(dropdownMenu.firstChild);
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
			button.dataset.asset_id = item.id;
			button.classList.add("dropdown-item");
			button.addEventListener("click", handleDropdownMenuItemClick);

			dropdownMenu.appendChild(button);
		});
	}

	document.addEventListener("turbolinks:load", function () {
		inputText = document.getElementById("asset_dropdown_input");

		if (!inputText) {
			return;
		}

		dropdownMenu = document.getElementById("asset_dropdown_menu");
		inputHidden = dropdownMenu.parentElement.querySelector(
			"input[type=hidden]"
		);

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
				$.get("/assets", {
					query: target.value
				}).then(data => populateDropdownMenu(data));
			}, 500);
		});
	});
})();
