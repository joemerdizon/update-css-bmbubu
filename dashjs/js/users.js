var $form;
var selectedDepartment;
var userAction;

$(document).ready(function () {
    $form = $('form');
    var datatable = $('#UserListTable').DataTable();
    var datatableRoles = $('#RoleListTable').DataTable();
    var datatableFunctionalRoles = $('#FunctionalRoleTable').DataTable();

    var showClients = $form.find('#ClientList option').length > 1;

    initializeDatepickers($form);

    showSuccessMsj();

    $form.find('#statusId').val($form.find('#Status').val());
    $form.find('#stateId').val($form.find('#USState').val());
    $form.find('#systemroleId').val($form.find('#systemrole').val());

    var nameStart = $('#Status').prop('name').replace('Status', '');
    $('[name^="' + nameStart + '"]').each(function (i, el) {
        $(el).prop('name', $(el).prop('name').replace(nameStart, ''));
    });

    $form.find('#create-user').on('click', function () {
        userAction = 'AddUser';
        var userModal = $form.find('#user-modal');
        resetForm(userModal);
        selectedDepartment = undefined;
        userModal.find('.modal-header .modal-title').text('New User');
        userModal.find('#startdate-container').show();
        userModal.find('#userId').val('');
        $form.find('#ClientList').trigger('change').removeAttr('disabled');
        $form.find('#systemrole').removeAttr('disabled');
        $form.find('select').trigger('change');
        userModal.modal('show');
        return false;
    });

    $form.find('#ClientList').on('change', function () {

        var clId = $(this).val();

        loadUserTitles(clId);
        loadClientTitles(clId);

        $form.find('#clientId').val(clId);
        $.ajax({
            type: "POST",
            url: "../../admin/AdminService.asmx/GetDepartmentsForClientID",
            data: '{ clientId: ' + $(this).val() + ' }',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                var departmentsOptions;
                $.each(data.d, function (i, el) {
                    departmentsOptions += "<option value='" + el.DepartmentID + "' >" + el.DepartmentName + "</option> \r\n";
                });

                $form.find('#departments').html(departmentsOptions).val(selectedDepartment).trigger('change');
                selectedDepartment = undefined;
            }
        });

        if (showClients) {
            var clientText = $('#ClientList option:selected').text();

            datatable.column(2).search('^' + clientText + '$', true).draw();
            datatableRoles.column(2).search('^' + clientText + '$', true).draw();
            datatableFunctionalRoles.column(1).search('^' + clientText + '$', true).draw();

            $form.find('#client-label-container .client-name').text(clientText);
        };
    });

    $form.find('#List').on('click', '.edit-user', function (e) {
        userAction = 'EditUser';
        var userModal = $form.find('#user-modal');
        resetForm(userModal);
        userModal.find('.modal-header .modal-title').text('Edit user: ' + $(this).data('firstname') + ' ' + $(this).data('lastname'));
        selectedDepartment = $(this).data('department');

        userModal.find("input[name='userId']").val($(this).data('userid'));
        userModal.find("input[name='fname']").val($(this).data('firstname'));
        userModal.find("input[name='lname']").val($(this).data('lastname'));
        userModal.find("input[name='title']").val($(this).data('title'));
        userModal.find("input[name='email']").val($(this).data('email'));
        userModal.find("input[name='telephone']").val($(this).data('telephone'));
        userModal.find("input[name='address1']").val($(this).data('address1'));
        userModal.find("input[name='address2']").val($(this).data('address2'));
        userModal.find("input[name='city']").val($(this).data('city'));
        userModal.find("input[name='zipcode']").val($(this).data('zipcode'));
        userModal.find("input[name='username']").val($(this).data('username'));

        userModal.find("#USState").val($(this).data('state')).trigger('change');
        userModal.find("#departments").val($(this).data('department')).trigger('change');
        userModal.find("#Status").val($(this).data('status').toLowerCase()).trigger('change');
        userModal.find("#systemrole").val($(this).data('role')).trigger('change').removeAttr('disabled');;

        userModal.find("#cmbClientTitles").val($(this).data('clienttitleid')).trigger('change').removeAttr('disabled');;
        userModal.find("#cmbUserTitles").val($(this).data('usertitleid')).trigger('change').removeAttr('disabled');;

        userModal.find('select').trigger('change');
        userModal.modal('show');
        return false;
    });

    $form.find('#save-user').on('click', function () {
        var container = $form.find('#user-modal');

        var arr = container.find('.form').find(':input').serializeArray();

        $.ajax({
            type: "POST",
            url: "../../admin/AdminService.asmx/" + userAction,
            data: serializeArrayToJSON(arr),
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
                    if (userAction == 'AddUser') {
                        $form.find('#successMsj').val('The user was created successfully');
                    } else {
                        $form.find('#successMsj').val('The user was edited successfully');
                    };

                    showLoadingScreen();
                    doPostBack();
                } else {
                    showErrorMsgs(container, data.d.Errors);
                };
            }
        });
    });

    $form.find('#create-new-client-admin').on('click', function () {
        $form.find('.modal').modal('hide');
        $form.isLoading();
        window.location = "/dashjs/admin/users.aspx?action=NewUserAdmin&clientId=" + $form.find('#new-admin-user').find('#clientId').val();
    });

    if (!showClients) {
        $form.find('#ClientList').trigger('change');
        $form.find('#clients-container').remove();
        $form.find('#client-label-container').hide();
    };

    $form.find("input[name='username']").on('change', function () {
        $.ajax({
            type: "POST",
            url: "../../admin/AdminService.asmx/ValidateUniqueUsername",
            data: '{ username: "' + $(this).val() + '", userId: "' + $form.find('#userId').val() + '" }',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                var errorField = $form.find('#username-error');
                if (data.d) {
                    errorField.hide();
                    errorField.closest('.form-group').removeClass('error');
                }
                else {
                    errorField.closest('.form-group').addClass('error');
                    errorField.show();
                };
            }
        });
    });

    $form.on('click', "a.edit-functional-role", function () {
        showFunctionalRoleModal($(this).data('title'), $(this).data('id'));
    });

    if ($form.find('#selectedClient').val() != '') {
        $form.find('#ClientList').val($form.find('#selectedClient').val());
        $form.find('#selectedClient').val('');
    };

    $("body").on('click', '.reset-user-password', function () {
        var userID = $(this).data('userId');

        bootbox.confirm("An email will be sent to the user with instructions on how to reset its password, are you sure you want to proceed?", function (result) {
            if (result) {
                call('/ManageUPWebService.asmx/ResetUserPassword', JSON.stringify({ userID: userID }), function (response) {
                    var result = response.d;
                    $('#error-msg').html('');

                    if (result.Success) {
                        bootbox.alert("A password reset email was sent to the user");
                    } else {
                        showErrorMsgs($('#error-msg'), result.Errors);
                    }
                });
            }
        });
    });

    showAdminUserCreation();
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

var showAdminUserCreation = function () {
    var adminUserCreation = $form.find('#adminUserCreation');
    if (adminUserCreation.val() != '') {
        userAction = 'AddUser';
        var userModal = $form.find('#user-modal');
        resetForm(userModal);
        selectedDepartment = undefined;
        userModal.find('.modal-header .modal-title').text('New Admin User For New Client');
        userModal.find('#startdate-container').show();
        $form.find('#ClientList').val(adminUserCreation.val()).trigger('change');
        $form.find('#systemrole').val(3).trigger('change').attr('disabled', 'disabled');
        userModal.modal('show');
        adminUserCreation.val('');
    };
};

var resetForm = function (container) {
    if (typeof container === "undefined") {
        container = $form;
    };

    container.find('.reset-input').val('').trigger('change');
    container.find('.with-datepicker').datepicker('update', new Date());
    container.find('.form .alert-error').hide();
};

var showFunctionalRoleModal = function (title, operationalRoleID) {
    var functionalRoleModal = $('#functional-role-modal');
    var defaultData = {
        id: '',
        title: ''
    };

    var data = $.extend({}, defaultData, { id: operationalRoleID, title: title });

    functionalRoleModal.find('#functionalRoleID').val(data.id);
    functionalRoleModal.find('#funcionalRoleName').val(data.title);

    functionalRoleModal.modal('show');
};

var saveFunctionalRole = function () {
    var functionalRoleModal = $('#functional-role-modal');
    var data = {
        functionalRoleID: functionalRoleModal.find('#functionalRoleID').val(),
        clientId: getCurrentClientID(),
        title: functionalRoleModal.find('#funcionalRoleName').val()
    };

    var url = data.functionalRoleID != '' ? 'updateClientTitle' : 'addClientTitle';

    call("../../admin/AdminService.asmx/" + url, JSON.stringify(data), function (response) {
        if (response.d.completed) {
            $('#successMsj').val('The Functional Role was ' + (data.functionalRoleID != '' ? 'edited' : 'added') + ' successfully');
            doPostBack();
        }
        else {
            showErrorMsgs(functionalRoleModal.find('.modal-body'), response.d.errors);
        };
    });
}

var doPostBack = function () {
    $form.find('.modal').modal('hide');
    showLoadingScreen();
    $form.submit();
};

function loadUserTitles(clientId) {
    var userTitles = callActionOnServer('getUserTitles', '{ clientId: ' + clientId.toString() + ' }', false, false);

    var options = '';


    $.each(userTitles, function (index, userTitle) {
        options += "<option value='" + userTitle.RoledID + "' >" + userTitle.RoleName + "</option> \r\n";
    });

    $form.find('#cmbUserTitles').html(options).trigger('change');


}

function loadClientTitles(clientId) {
    var res = callActionOnServer('getClientTitles', '{ clientId: ' + clientId.toString() + ' }', false, false);

    var str = '';


    $.each(res, function (i, el) {
        str += "<option value='" + el.TitleID + "' >" + el.TitleName + "</option> \r\n";
    });

    $form.find('#cmbClientTitles').html(str).trigger('change');

}

var aspxPage = 'users.aspx';
function callActionOnServer(action, params, showLoading, hideLoading) {
    var res;
    if (showLoading) processLoading();

    $.ajax({
        type: "POST", url: aspxPage + "/" + action, data: params, contentType: "application/json; charset=utf-8", dataType: "json",
        success: function (result) {
            res = result.d;
        },
        failure: function (response) {
            alert(response.d);
        },
        async: false
    });

    if (hideLoading) endProcessLoading();
    return res;
}
