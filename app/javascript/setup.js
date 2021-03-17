const applyCurrencyMask = input => {
	const value = String(input.value).replace(/\D/g, "");
	const num = (Number(value) / 100)
		.toFixed(2)
		.replace(".", ",")
		.replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1.");

	input.value = "$" + num;
};

const applyCurrencyMaskOnLoad = input => {
	input.value = input.value.replace(/(\d+)\.(\d{1})$/g, "$1.$20");
	applyCurrencyMask(input);
};

const handleCurrencyInputEvent = evt => {
	applyCurrencyMask(evt.target);
};

const applyIntegerMask = input => {
	input.value = String(input.value).replace(/\D/g, "");
};

const handleIntegerInputEvent = evt => {
	applyIntegerMask(evt.target);
};

document.addEventListener("turbolinks:load", function () {
	document.querySelectorAll(".integer-input").forEach(function (el) {
		applyIntegerMask(el);

		el.addEventListener("blur", handleIntegerInputEvent);
		el.addEventListener("keyup", handleIntegerInputEvent);
		el.addEventListener("change", handleIntegerInputEvent);
	});

	document.querySelectorAll(".money-input").forEach(function (el) {
		applyCurrencyMaskOnLoad(el);

		el.addEventListener("blur", handleCurrencyInputEvent);
		el.addEventListener("keyup", handleCurrencyInputEvent);
		el.addEventListener("change", handleCurrencyInputEvent);
	});
});
