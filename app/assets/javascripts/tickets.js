$(function(){
	$("#js-add-file").on("ajax:success", function(event, data) {
		$("#attachments").append(data);
		return $(this).data("params", { index: $("#attachments div.file").length });
	});
});