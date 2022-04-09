var $form;
var userAction;

$(document).ready(function () {

    $form = $('form');
    var datatable = $("#DepartmentListTable").DataTable();
    var showClients = $form.find('#ClientList option').length > 1;

    showSuccessMsj();

    $form.find('#create-department').on('click', function () {
        userAction = 'AddDepartment';
        var userModal = $form.find('#department-modal');
        resetForm(userModal);
        userModal.find('.modal-header h2').text('New Department');
        userModal.find('#userId').val('');


        $form.find('#ClientList').trigger('change').removeAttr('disabled');
        $form.find('#systemrole').removeAttr('disabled');
        userModal.modal('show');
    });

    $form.find('.bootstrap-timepicker input').timepicker({ defaultTime: false });

    $form.find('select').on('change', function () {
        $(this).siblings('.value-input').val($(this).val());
    });

    $form.find('#ClientList').on('change', function () {
        $form.find('#clientId').val($(this).val());

        if (showClients) {
            var clientText = $('#ClientList option:selected').text();
            datatable.column(2).search('^' + clientText + '$', true).draw();
            $form.find('#client-label-container p').text(clientText);
        };
    });

    $form.find('#save-department').on('click', function () {
        var container = $form.find('#department-modal');

        $.ajax({
            type: "POST",
            url: "../../admin/AdminService.asmx/" + userAction,
            data: serializeArrayToJSON(container.find('.form-horizontal').find(':input').serializeArray()),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            beforeSend: function () {
                //container.find('.modal-body').isLoading();
            },
            success: function (data) {
                //container.find('.modal-body').isLoading("hide");
                if (data.d.Success) {
                    container.modal('hide');
                    resetForm(container);
                    $form.find('#successMsj').val('The department was created successfully');

                    doPostBack();
                } else {
                    var containerErrors = $form.find('#department-modal .modal-body');
                    showErrorMsgs(containerErrors, data.d.Errors);
                };
            }
        });
    });

    if (!showClients) {
        $form.find('#ClientList').trigger('change');
        $form.find('#clients-container').remove();
        $form.find('#client-label-container').hide();
    };

    if ($form.find('#selectedClient').length > 0 && $form.find('#selectedClient').val() != '') {
        $form.find('#ClientList').val($form.find('#selectedClient').val());
        $form.find('#selectedClient').val('');
    };

    $form.find('#ClientList').trigger('change');
});

var showSuccessMsj = function () {
    var msg = $form.find('#successMsj');
    if (msg.val() != '') {
        $form.find('#success-msg').text(msg.val()).show('fast');
        setTimeout(function () {
            $form.find('#success-msg').hide('fast');
            msg.val('');
        }, 5000);
    };
};

var resetForm = function (container) {
    if (typeof container === "undefined") {
        container = $form;
    };

    container.find('.reset-input').val('').trigger('change');
    container.find('.with-datepicker').datepicker('update', new Date());
    container.find('.form-horizontal .alert-error').hide();
};

var doPostBack = function () {
    $form.find('.modal').modal('hide');
    //$form.isLoading();
    $form.submit();
};