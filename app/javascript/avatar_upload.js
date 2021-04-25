(function () {
	function previewImageFile(file, image) {
		if (!file) {
			return false;
		}

		if (!file.type.match(/image.*/)) {
			throw new Error(`Invalid file format: ${file.type}`);
		}

		const reader = new FileReader();
		reader.onload = function (e) {
			image.src = e.target.result;
		};

		reader.readAsDataURL(file);
	}

	document.addEventListener("turbolinks:load", function () {
		const avatarInput = document.querySelector("input#user_avatar");

		if (!avatarInput) {
			return false;
		}

		const status = document.getElementById("avatar-status");
		const imgPreview = document.getElementById("current-user-avatar-preview");

		function updatePreviewAvatar(file) {
			try {
				previewImageFile(file, imgPreview);
				status.innerHTML = "";
			} catch (err) {
				status.innerHTML = err.message;
			}
		}

		if (avatarInput.files) {
			updatePreviewAvatar(avatarInput.files[0]);
		}

		avatarInput.addEventListener("change", function () {
			if (!this.files) {
				return false;
			}

			updatePreviewAvatar(this.files[0]);
		});
	});
})();
