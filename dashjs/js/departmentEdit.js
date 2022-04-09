var $form;
var action;

$(document).ready(function () {
    $form = $('form');
    var datatable = $("#DepartmentBranchListTable").DataTable();

    showSuccessMsj();

    $form.find('#create-departmentbranch').on('click', function () {
        action = 'AddDepartmentBranch';
        var departmentBranchModal = $form.find('#department-branch-modal');
        resetForm(departmentBranchModal);
        departmentBranchModal.find('.modal-header h2').text('New Branch');
        departmentBranchModal.find('#departmentBranchId').val('');
        departmentBranchModal.modal('show');
    });

    $form.find('select').on('change', function () {
        $(this).siblings('.value-input').val($(this).val());
    });

    $form.find('#ClientList').on('change', function () {
        $form.find('#clientId').val($(this).val());
    });

    $form.find('.bootstrap-timepicker input').timepicker({ defaultTime: false });

    $form.find('#DepartmentBranchListTable').on('click', '.edit-department-branch', function (e) {
        action = 'EditDepartmentBranch';
        var departmentBranchModal = $form.find('#department-branch-modal');
        resetForm(departmentBranchModal);
        departmentBranchModal.find('.modal-header h2').text('Edit Branch: ' + $(this).data('name'));

//        departmentBranchModal.find("input[name='name']").val($(this).data('name'));
//        departmentBranchModal.find("input[name='description']").val($(this).data('description'));
//        departmentBranchModal.find("input[name='addressLine1']").val($(this).data('addressline1'));
//        departmentBranchModal.find("input[name='addressLine2']").val($(this).data('addressline2'));
//        departmentBranchModal.find("input[name='city']").val($(this).data('city'));
//        departmentBranchModal.find("input[name='zipcode']").val($(this).data('zipcode'));
//        departmentBranchModal.find("#departmentBranchId").val($(this).data('departmentbranchid'));
//        departmentBranchModal.find("#USState").val($(this).data('state')).trigger('change');
        $('#branchName').val($(this).data('name'));
        $('#branchDescription').val($(this).data('description'));
        $('#branchAddressLine1').val($(this).data('addressline1'));
        $('#branchAddressLine2').val($(this).data('addressline2'));
        $('#branchCity').val($(this).data('city'));
        $('#branchZipcode').val($(this).data('zipcode'));

        
        $("#departmentBranchId").val($(this).data('departmentbranchid'));
        $("#USState").val($(this).data('state')).trigger('change');

        departmentBranchModal.modal('show');
    });

    $form.find('#save-department-branch').on('click', function () {
        var container = $form.find('#department-branch-modal');
        var stateId = $("#USState").val();
        if (stateId==null) stateId = 0;
        var obj1 = { name:"addressLine1", value:$('#branchAddressLine1').val() };
        var obj2 = { name:"addressLine2", value:$('#branchAddressLine2').val() };
        var obj3 = { name:"description", value:$('#branchDescription').val() };
        var obj4 = { name:"name", value:$('#branchName').val() };
        var obj5 = { name:"city", value:$('#branchCity').val() }; //$('#departmentId').val()
        var obj6 = { name:"stateId", value:stateId }; //$('#clientId').val()
        var obj7 = { name:"DepartmentId", value:departmentId }; //$('#clientId').val()
        var obj8 = { name:"zipcode", value:$('#branchZipcode').val() }; //$('#clientId').val()
        var obj9 = { name:"departmentBranchId", value:$("#departmentBranchId").val() }; //$('#clientId').val()//var obj9 = { name:"departmentBranchId", value:$('departmentBranchId').val() }; //$('#clientId').val()
        
        var arr = [ obj1, obj2, obj3, obj4, obj5, obj6, obj7, obj8, obj9 ];
        
        $.ajax({
            type: "POST",
            url: "../../admin/AdminService.asmx/" + action,
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
                    if (action == 'AddDepartmentBranch') {
                        $form.find('#successMsj').val('The Branch was created successfully');
                    } else {
                        $form.find('#successMsj').val('The Branch was edited successfully');
                    };

                    doPostBack();
                } else {
                    var containerErrors = $form.find('#department-branch-modal .modal-body');
                    showErrorMsgs(containerErrors, data.d.Errors);
                };
            }
        });
    });

    $form.find('#save-deparment').on('click', function () {
        
        
        var obj1 = { name:"Name", value:$('#Name').val() };
        var obj2 = { name:"Description", value:$('#Description').val() };
        var obj3 = { name:"StartTime", value:$('#StartTime').val() };
        var obj4 = { name:"EndTime", value:$('#EndTime').val() };
        var obj5 = { name:"departmentId", value:departmentId }; //$('#departmentId').val()
        var obj6 = { name:"clientId", value:clientId }; //$('#clientId').val()

        var arr = [ obj1, obj2, obj3, obj4, obj5, obj6 ];
        //alert(serializeArrayToJSON(arr));

        var container = $form.find('#edit-deparment-container');
        container.find("input[name='departmentId']").val($form.find('#DepartmentId').val());
        var obj = serializeArrayToJSON(arr); //serializeArrayToJSON(container.find(':input').serializeArray())
        
        //alert(obj);
        $.ajax({
            type: "POST",
            url: "../../admin/AdminService.asmx/EditDepartment",
            data: obj,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            beforeSend: function () {
                $form.find('#successMsj').hide('fast');
                container.find('.alert-error').hide('fast');
                //container.isLoading();
            },
            success: function (data) {
                //container.isLoading("hide");
                if (data.d.Success) {
                    $form.find('#successMsj').val('The Department was edited successfully');
                    showSuccessMsj();
                } else {
                    showErrorMsgs(container, data.d.Errors);
                };
            }
        });
    });

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
    $form.submit();
};