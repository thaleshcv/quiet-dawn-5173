import $ from "jquery";
import "select2";
import "select2/dist/css/select2.css";
import "select2-bootstrap-theme/dist/select2-bootstrap.min.css";

$.fn.select2.defaults.set("theme", "bootstrap");
$.fn.select2.defaults.set("width", "100%");

const applyCurrencyMaskOnLoad = input => {
	input.value = input.value.replace(/(\d+)\.(\d{1})$/g, "$1.$20");
	applyCurrencyMask(input);
};

const applyCurrencyMask = input => {
	const value = String(input.value).replace(/\D/g, "");
	const num = (Number(value) / 100)
		.toFixed(2)
		.replace(".", ",")
		.replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1.");

	input.value = "$" + num;
};

document.addEventListener("turbolinks:load", function () {
	$("#investment_asset_id").select2();

	$(".integer-input").each(function (_index, input) {
		input.value = String(input.value).replace(/\D/g, "");

		$(input).on("change blur keyup", function () {
			input.value = String(input.value).replace(/\D/g, "");
		});
	});

	$(".money-input").each(function (_index, input) {
		// apply mask on initial value
		applyCurrencyMaskOnLoad(input);

		$(input).on("change blur keyup", function () {
			applyCurrencyMask(input);
		});
	});
});
