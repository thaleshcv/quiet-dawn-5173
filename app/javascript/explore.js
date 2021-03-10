/**
 * Setup explore page adding a dropdown menu to be used as input autocomplete.
 *
 * As the user inputs text in the search field, the dropdown is populated with
 * assets which abbreviation or name matches the text entered.
 */
(function () {
	let inputName, inputId, dropdownMenu;

	function handleDropdownMenuItemClick(evt) {
		inputId.value = evt.target.dataset.asset_id;
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

		items.forEach(function (item) {
			const button = document.createElement("button");
			button.innerText = `${item.abbreviation} ${item.name}`;
			button.dataset.asset_id = item.id;
			button.classList.add("dropdown-item");
			button.addEventListener("click", handleDropdownMenuItemClick);

			dropdownMenu.appendChild(button);
		});
	}

	document.addEventListener("turbolinks:load", function () {
		inputName = document.getElementById("explore_asset_name");
		inputId = document.getElementById("explore_asset_id");
		dropdownMenu = document.getElementById("explore_dropdown_menu");

		if (!inputName) {
			return;
		}

		let queryTimeoutId;

		inputName.addEventListener("keyup", function (evt) {
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

				return;
			}

			queryTimeoutId = setTimeout(function () {
				$.get("/explore/assets", {
					query: target.value
				}).then(data => populateDropdownMenu(data));
			}, 500);
		});
	});
})();
