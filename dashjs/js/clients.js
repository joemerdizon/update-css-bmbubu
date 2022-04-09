var $form;

$(document).ready(function () {
    var clientAction;

    $form = $('form');
    $form.find('.with-datepicker').datepicker({
        beforeShow: function () {
            $form.find('#ui-datepicker-div').addClass('custom-datepicker');
        }
    });
    $form.find('.with-datepicker').siblings('.show-calendar').on('click', function () {
        $form.find(this).siblings('.with-datepicker').datepicker("show");
    });

    showSuccessMsj();

    $form.find('#create-client').on('click', function () {
          clientAction = 'AddClient';
          var clientModal = $form.find('#client-modal');
          resetForm(clientModal);
          clientModal.find('.modal-header h2').text('New Client');
          clientModal.find('#startdate-container').show();
          clientModal.modal('show');
    });

    $form.find('#USState').on('change', function () {
        $form.find('#stateId').val($(this).val());
    });

    $form.find('.go-users-tab').on('click', function () {
        window.location.href = './users.aspx?selectClientId=' + $(this).data('clientid');
    });

    $form.find('#List').on('click', '.edit-client', function () {
        clientAction = 'EditClient';
        var clientModal = $form.find('#client-modal');
        resetForm(clientModal);
        clientModal.find('.modal-header h2').text('Edit client: ' + $(this).data('name'));

        clientModal.find("input[name='clientId']").val($(this).data('clientid'));
        clientModal.find("input[name='name']").val($(this).data('name'));
        clientModal.find("input[name='addressLine1']").val($(this).data('addressline1'));
        clientModal.find("input[name='addressLine2']").val($(this).data('addressline2'));
        clientModal.find("input[name='city']").val($(this).data('city'));
        clientModal.find("#USState").val($(this).data('state')).trigger('change');
        clientModal.find("input[name='zipcode']").val($(this).data('zipcode'));
        clientModal.find("input[name='clientTitle']").val($(this).data('title'));
        clientModal.find("input[name='clientBranding']").val($(this).data('branding'));
        clientModal.find("input[name='startDate']").datepicker('update', $(this).data('createdon'));
        clientModal.find("input[name='endDate']").datepicker('update', $(this).data('enddate'));
        clientModal.find("input[name='totalLicenses']").val($(this).data('totalicenses'));

        clientModal.find('#startdate-container').hide();
        clientModal.modal('show');
    });

    $form.find('#save-client').on('click', function () {
        var container = $form.find('#client-modal');

        $.ajax({
            type: "POST",
            url: "../../admin/AdminService.asmx/" + clientAction,
            data: serializeArrayToJSON(container.find('.form-horizontal').find(':input').serializeArray()),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            beforeSend: function () {
                container.find('.modal-body').isLoading();
            },
            success: function (data) {
                container.find('.modal-body').isLoading("hide");
                if (data.d.Success) {
                    container.modal('hide');
                    resetForm(container);
                    if (clientAction == 'AddClient') {
                        var newAdminClientModal = $form.find('#new-admin-user');
                        $form.find('#successMsj').val('The client was created successfully');
                        newAdminClientModal.find('#clientId').val(data.d.Data);
                        newAdminClientModal.modal('show');
                    } else {
                        $form.find('#successMsj').val('The client was edited successfully');
                        doPostBack();
                    };
                } else {
                    var errorMsg = '<ul>';
                    $.each(data.d.Errors, function (i, el) {
                        errorMsg += '<li>' + el + '</li>';
                    });

                    errorMsg += '</ul>';
                    container.find('.alert-error').html(errorMsg).show('fast');
                    setTimeout(function () {
                        container.find('.alert-error').hide('fast');
                    }, 7000);
                };
            }
        });
    });

    $form.find('#create-new-client-admin').on('click', function () {
        $form.find('.modal').modal('hide');
        $form.isLoading();
        window.location = "/dashjs/admin/users.aspx?action=NewUserAdmin&clientId=" + $form.find('#new-admin-user').find('#clientId').val();
    });
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
    $form.isLoading();
    $form.submit();
};