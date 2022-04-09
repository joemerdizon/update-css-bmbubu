$(document).ready(function () {
    LoadFisrtCat("");
    LoadSecondCat("");
    LoadOtherCat("");
    LoadFourthCat("");
});

$(document).ajaxStop(function () {
    $("#LoadingModal").modal('hide');
});

$(document).ajaxStart(function () {
    $("#LoadingModal").modal('show');
});

function UpdateCat(catid) {
    var NewValue = "";
    var OldValue = "";

    switch (parseInt(catid)) {
        case 1:
            OldValue = $("#PlaybookCat1").val();
            NewValue = $("#firstcat").val();
            break;
        case 2:
            OldValue = $("#PlaybookCat2").val();
            NewValue = $("#secondcat").val();
            break;
        case 3:
            OldValue = $("#PlaybookCat3").val();
            NewValue = $("#thirdcat").val();
            break;
        case 4:
            OldValue = $("#PlaybookCat4").val();
            NewValue = $("#fourthcat").val();
            break;
    }

    if (NewValue === "" || NewValue.trim() === OldValue.trim()) {
        ShowErrorModal('Please enter a valid category name.');
        return;
    }
    else {
        $.ajax({
            async: true,
            type: "POST",
            url: "../../ManageUPWebService.asmx/UpdatePlaybookCat",
            data: JSON.stringify({ CatID: catid, OldValue : "" + OldValue + "", NewValue : "" + NewValue + "" }) ,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                if (data.d != 0) {
                    $("#SuccessMsg").html('');

                    var msg = "";

                    if (data.d == 1) {
                        msg = data.d + " record updated.";
                    }
                    else {
                        msg = data.d + " records updated.";
                    }

                    $("#SuccessMsg").html(msg);
                    $("#SuccessModal").modal('show');

                    switch (parseInt(catid)) {
                        case 1:
                            LoadFisrtCat(NewValue);
                          //  $("#firstcat").val('');
                            break;
                        case 2:
                            LoadSecondCat(NewValue);
                          //  $("#secondcat").val('');
                            break;
                        case 3:
                            LoadOtherCat(NewValue);
                          //  $("#thirdcat").val('');
                            break;
                        case 4:
                            LoadFourthCat(NewValue);
                           // $("#fourthcat").val('');
                            break;
                    }
                }
            },
        });
    }
}

function ShowErrorModal(msg) {
    $("#ErrorMsg").html('');
    $("#ErrorMsg").html(msg);
    $("#ErrorModal").modal('show');
}

function LoadFisrtCat(defval) {
    $.ajax({
        beforeSend: function () {
        },
        async: true,
        type: "POST",
        url: "../../ManageUPWebService.asmx/GetPlaybookFirstCat",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: {},
        success: function (data) {
            var mySelect = $("#PlaybookCat1");
            mySelect.empty();
            mySelect.append(
                    $('<option></option>').val('0').html('Select')
                );
            $.each(data.d, function (val, text) {
                mySelect.append(
                    $('<option></option>').val(text.Value).html(text.Text)
                );
            });

            if (defval != "") {
                mySelect.val(defval);
            };
        },
        complete: function () {
        },
    });

    $('#PlaybookCat1').change(function (e) {
        $this = $(e.target);
        if ($this.val() != 0) {
            $("#firstcat").val('');
            $("#firstcat").val($this.val());
            $("#firstcatbtn").removeAttr("disabled");
        }
        else {
            $("#firstcatbtn").attr("disabled",true);
            $("#firstcat").val('');
        }
    })
}

function LoadSecondCat(defval){
            $.ajax({
                beforeSend: function () {
                },
                async: true,
                type: "POST",
                url: "../../ManageUPWebService.asmx/GetPlaybookSecondCatDistinct",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: {},
                success: function (data) {
                    var mySelect = $("#PlaybookCat2");
                    mySelect.empty();
                    mySelect.append(
                            $('<option></option>').val('0').html('Select')
                        );
                    $.each(data.d, function (val, text) {
                        mySelect.append(
                            $('<option></option>').val(text.Value).html(text.Text)
                        );
                    });

                    if (defval != "") {
                        mySelect.val(defval);
                    };
                },
                complete: function () {
                },
            });

            $('#PlaybookCat2').change(function (e) {
                $this = $(e.target);
                if ($this.val() != 0) {
                    $("#secondcat").val('');
                    $("#secondcat").val($this.val());
                    $("#secondcatbtn").removeAttr("disabled");
                }
                else {
                    $("#secondcat").val('');
                    $("#secondcatbtn").attr("disabled", true);
                }
            });
}

function LoadOtherCat(defval) {
    $.ajax({
        beforeSend: function () {
        },
        async: true,
        type: "POST",
        url: "../../ManageUPWebService.asmx/GetPlaybookOtherCatDistinct",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: {},
        success: function (data) {
            var mySelect = $("#PlaybookCat3");
            mySelect.empty();
            mySelect.append(
                    $('<option></option>').val('0').html('Select')
                );
            $.each(data.d, function (val, text) {
                mySelect.append(
                    $('<option></option>').val(text.Value).html(text.Text)
                );
            });

            if (defval != "") {
                mySelect.val(defval);
            };
        },
        complete: function () {
        },
    });

    $('#PlaybookCat3').change(function (e) {
        $this = $(e.target);
        if ($this.val() != 0) {
            $("#thirdcat").val('');
            $("#thirdcat").val($this.val());
            $("#thirdcatbtn").removeAttr("disabled");
        }
        else {
            $("#thirdcat").val('');
            $("#thirdcatbtn").attr("disabled", true);
        }
    });
}

function LoadFourthCat(defval) {
    $.ajax({
        beforeSend: function () {
        },
        async: true,
        type: "POST",
        url: "../../ManageUPWebService.asmx/GetPlaybookFourthCatDistinct",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: {},
        success: function (data) {
            var mySelect = $("#PlaybookCat4");
            mySelect.empty();
            mySelect.append(
                    $('<option></option>').val('0').html('Select')
                );
            $.each(data.d, function (val, text) {
                mySelect.append(
                    $('<option></option>').val(text.Value).html(text.Text)
                );
            });

            if (defval != "") {
                mySelect.val(defval);
            };
        },
        complete: function () {
        },
    });

    $('#PlaybookCat4').change(function (e) {
        $this = $(e.target);
        if ($this.val() != 0) {
            $("#fourthcat").val('');
            $("#fourthcat").val($this.val());
            $("#fourthcatbtn").removeAttr("disabled");
        }
        else {
            $("#fourthcat").val('');
            $("#fourthcatbtn").attr("disabled", true);
        }
    });
}