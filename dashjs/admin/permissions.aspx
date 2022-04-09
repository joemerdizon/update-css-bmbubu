<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="Static" MasterPageFile="~/MasterNewUi.Master" CodeBehind="permissions.aspx.cs" Inherits="ManageUPPRM.permissions" EnableEventValidation="false" EnableViewStateMac="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--<script src="../../admin/admin.js"></script>--%>

    <script>
        $(document).ready(function () {
            if (typeof userId !== 'undefined' && typeof userTitleId !== 'undefined') {
                var params = '{ "userId": ' + userId + ', "roleId": ' + userTitleId + ' }'
                var result = callActionOnServer('getPermissions',params,false, false);

                $('#permissionsList').html($('#permissions-content').tmpl(result));
            }
            Metronic.initUniform();

            $('input[type=radio][name=entityTypeSelectionRadio]').change(function () {
                toggleUserRoleContainers();
            });

            $('#<%=ClientList.ClientID%>').change(function () {
                BindUsers();
                BindRoles();
            });
            
            //Initialize client
            if (clientId != 0) {
                $('#<%=ClientList.ClientID%>').val(clientId);
            }
            BindUsers(function(){
                if (typeof userId !== 'undefined' && userId != 0)
                    $("#<%=UserSelect.ClientID%>").val(userId);
            });
            BindRoles(function(){
                if (typeof userTitleId !== 'undefined' && userTitleId != 0)
                    $("#<%=RoleSelect.ClientID%>").val(userTitleId);
            });
            
            //Initialize radio
            if (typeof userId !== 'undefined' && userId != 0) {
                $('#radioUser').prop('checked', true);
                $('#radioRole').prop('checked', false);
            } else if (typeof userTitleId !== 'undefined' && userTitleId != 0) {
                $('#radioUser').prop('checked', false);
                $('#radioRole').prop('checked', true);
            }
            $.uniform.update();
            toggleUserRoleContainers();

            $('#manage-button').click(function(){
                var typeRadioValue = $('input[name=entityTypeSelectionRadio]:checked').val();
                var url = aspxPage;

                if (typeRadioValue == 'user') {
                    var selectedUserID =  $("#<%=UserSelect.ClientID%>").val();
                    url = url + "?userTitleId=0&userId=" + selectedUserID; 
                } else {
                    var selectedRoleID =  $("#<%=RoleSelect.ClientID%>").val();
                    url = url + "?userId=0&userTitleId=" + selectedRoleID; 
                }

                window.location = url;
            });

            if (typeof userId == 'undefined' && typeof userTitle == 'undefined')
                $("#permissions-container").hide();
        });

        function doChangePermission(permissionName, permissionKey, permissionSection, permissionId) {
            var permissionCheckbox = $('#chk_' + permissionName + '_' + permissionKey + '_' + permissionSection);
            var granted = permissionCheckbox.is(":checked");
            console.log($('#chk_' + permissionName + '_' + permissionKey + '_' + permissionSection));
            console.log(granted);

            var params = '{ "granted": ' + granted.toString() + ', "userId" : ' + userId + ', "roleId": ' + userTitleId + ', "permissionName": "' + permissionName + '", "permissionKey": "' + permissionKey + '", "permissionSection": "' + permissionSection + '", "permissionId": ' + permissionId + ', "type": 0 }';
            var result = callActionOnServer('savePermission',params,false, false);

            if (permissionName == 'read' && granted) {
                var accessPermissionCheckbox = permissionCheckbox.closest('tr').find('.access-checkbox');
                if (!accessPermissionCheckbox.is(":checked")) 
                    accessPermissionCheckbox.click();
            }

            if (permissionCheckbox.hasClass('access-checkbox') && !granted) {
                var readPermissionCheckbox = permissionCheckbox.closest('tr').find('.read-checkbox');
                if (readPermissionCheckbox.is(":checked")) 
                    readPermissionCheckbox.click();
            }
        }
        
        var aspxPage = 'permissions.aspx';

        function callActionOnServer(action, params, showLoading, hideLoading) {
            var res;
            if (showLoading) processLoading();

            $.ajax({
                type: "POST", url: aspxPage + "/" + action, data: params, contentType: "application/json; charset=utf-8", dataType: "json",
                success: function (result) {
                    res = result.d;
                    if (res==null)
                    {
                        var message = 'The permission has been updated successfully'
                        if (!toastrMessageAlreadyExists(message)) {
                            showToastNotification(message, 'Permission Update');
                        }
                        //$('#successMsj').val('The permission  has been updated successfully');
                        //showSuccessMsj();
                    }
                },
                failure: function (response) {
                    alert(response.d);
                },
                async: false
            });

            if (hideLoading) 
                endProcessLoading();
                
            return res;
        }

        function BindUsers(callback){
            $("#<%=UserSelect.ClientID%>").empty();
            var clientID = $('#<%=ClientList.ClientID%>').val();

            call(aspxPage + "/GetUsers", JSON.stringify({ clientID: clientID }), function(response){
                var users = response.d;

                $.each(users, function(index, value){
                    var option = $('<option></option>').attr("value", value.UserID).text(value.FullName);
                    $("#<%=UserSelect.ClientID%>").append(option);
                });

                if (callback) 
                    callback();
            });
        }

        function BindRoles(callback){
            $("#<%=RoleSelect.ClientID%>").empty()
            var clientID = $('#<%=ClientList.ClientID%>').val();

            call(aspxPage + "/GetRoles", JSON.stringify({ clientID: clientID }), function(response){
                var roles = response.d;

                $.each(roles, function(index, value){
                    var option = $('<option></option>').attr("value", value.RoledID).text(value.RoleName);
                    $("#<%=RoleSelect.ClientID%>").append(option);
                });

                if (callback) 
                    callback();
            });
        }
        
        function toggleUserRoleContainers()
        {
            $('input[name=entityTypeSelectionRadio]').attr("disabled", true);
            var radioValue = $('input[name=entityTypeSelectionRadio]:checked').val();

            if (radioValue == 'user') {
                $("#role-select-container").fadeOut(function () {
                    $("#user-select-container").fadeIn(function () {
                        $('input[name=entityTypeSelectionRadio]').attr("disabled", false);
                    });
                });
            } else {
                $("#user-select-container").fadeOut(function () {
                    $("#role-select-container").fadeIn(function () {
                        $('input[name=entityTypeSelectionRadio]').attr("disabled", false);
                    });
                });
            }
        }

        var showSuccessMsj = function () {
            var msg = $('#successMsj');
            if (msg.val() != '') {
                $('#success-msg').text(msg.val()).show('fast');
                setTimeout(function () {
                    $('#success-msg').hide('fast');
                    msg.val('');
                }, 5000);
            };
        };

        function toastrMessageAlreadyExists(message){
            var toastrMessageAlreadyExists = false;

            var $toastContainer = $('#toast-container');
            if ($toastContainer.length > 0) {
                var $infoToastr = $toastContainer.find('.toast-success');
                if ($infoToastr.length > 0) {
                    var currentText = $infoToastr.find('.toast-message').text();
                    var areEqual = message.toUpperCase() === currentText.toUpperCase();
                    if (areEqual) {
                        toastrMessageAlreadyExists = true;
                    }
                }
            }

            return toastrMessageAlreadyExists;
        }
    </script>
    <style>
        #tabPermissions .center, #tabPermissions th {
            text-align: center;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input type="hidden" id="selectedClient" runat="server" />
    <input type="hidden" id="adminUserCreation" runat="server" />
    <input type="hidden" id="successMsj" runat="server" />

    <div class="page-content-wrapper">
        <div class="page-content">

            <%--Admin Menu--%>
            <div class="portlet light bordered" data-team="false">
                <div class="portlet-title" style="border: none;">
                    <div class="tabbable-line col-md-9">
                        <ul class="nav nav-tabs home-tabs nav-justified task-widget" id="AdminTabs">
                            <asp:Literal ID="AdminMenu" runat="server" />
                        </ul>
                    </div>
                </div>
            </div>

            <div class="row-fluid">
                <div id="success-msg" class="alert alert-success span12" style="display: none;"></div>
            </div>

            <div class="portlet box grey-silver">
                <div class="portlet-title">
                    <div class="caption">Permissions</div>
                </div>
                <div class="portlet-body">
                    <div class="form">
                        <div class="form-horizontal">
                            <div class="form-body">
                                <div class="form-group" id="ClientsContainer" runat="server">
                                    <label class="col-md-2 col-md-offset-1 control-label">Client</label>
                                    <div class="col-md-3">
                                        <asp:DropDownList ID="ClientList" runat="server" CssClass="form-control" AppendDataBoundItems="true">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-md-2 col-md-offset-1 control-label">Manage Permissions For</label>
                                    <div class="radio-list col-md-3">
                                        <label class="radio-inline">
                                            <input type="radio" name="entityTypeSelectionRadio" id="radioUser" value="user" checked="checked"/> User</label>
                                        <label class="radio-inline">
                                            <input type="radio" name="entityTypeSelectionRadio" id="radioRole" value="role" /> Role</label>
                                    </div>
                                </div>
                                <div class="form-group" id="user-select-container">
                                    <label class="col-md-2 col-md-offset-1 control-label">User</label>
                                    <div class="col-md-3">
                                        <asp:DropDownList ID="UserSelect" runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                </div>
                                <div class="form-group" id="role-select-container" style="display:none;">
                                    <label class="col-md-2 col-md-offset-1 control-label">Role</label>
                                    <div class="col-md-3">
                                        <asp:DropDownList ID="RoleSelect" runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col-md-3 col-md-offset-3">
                                        <button type="button" class="btn btn-primary" id="manage-button">Manage</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="permissions-container">
                        <hr />
                        <div class="note note-info">
                            <h4>Managing permissions for <span runat="server" id="labObject"></span> <span class="label label-info"><i class="fa fa-<%=labObject.InnerText == "user" ? "user" : "users" %>"></i> <b runat="server" id="labName"></b></span></h4>
                            <h5 runat="server" id="labRolePermissions"></h5>
                        </div>
                        <table id="tabPermissions" class="table table-hover table-light">
                            <thead>
                                <tr>
                                    <th>Module</th>
                                    <th class="withTooltip" title="This permission allows the user to access the module with viewing rights.">Access</th>
                                    <th class="withTooltip" title="This permission gives the user right to create/edit entities within the module.">Create</th>
                                    <th class="withTooltip" title="This permission allows users to archive and unarchive entities within the module.">Archive</th>
                                    <th class="withTooltip" title="This permission shows a side menu link for accessing the module. Keep in mind that when this permission is added, 'access' permission will be automatically granted for the user to able to access the module.">Menu View</th>
                                </tr>
                            </thead>
                            <tbody id="permissionsList">
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/x-jquery-tmpl" id="permissions-content">
        <tr title="${Description}">
            <td><b>${Description}</b></td>
            <td class="center">{{if _access != null }}<input class="access-checkbox" id="chk_${Name}_${PermissionKey}_${Section}" type="checkbox" {{if (_access == true || accessInherited == true) }} checked {{if accessInherited == true }} disabled readonly {{/if}} {{/if}} onClick="doChangePermission('${Name}','${PermissionKey}','${Section}',${PermissionID});" />{{/if}}</td>
            <td class="center">{{if _create != null }}<input class="create-checkbox" id="chk_create_${PermissionKey}_${Section}" type="checkbox" {{if _create == true || createInherited == true }} checked {{if createInherited == true }} disabled readonly {{/if}} {{/if}} onClick="doChangePermission('create','${PermissionKey}','${Section}',${PermissionID});" />{{/if}}</td>
            <td class="center">{{if _delete != null }}<input class="delete-checkbox" id="chk_delete_${PermissionKey}_${Section}" type="checkbox" {{if _delete == true || deleteInherited == true }} checked {{if deleteInherited == true }} disabled readonly {{/if}} {{/if}} onClick="doChangePermission('delete','${PermissionKey}','${Section}',${PermissionID});" />{{/if}}</td>
            <td class="center">{{if _read   != null }}<input class="read-checkbox" id="chk_read_${PermissionKey}_${Section}" type="checkbox" {{if _read == true || readInherited == true }} checked {{if readInherited == true }} disabled readonly {{/if}} {{/if}} onClick="doChangePermission('read','${PermissionKey}','${Section}',${PermissionID});"/>{{/if}}</td>
        </tr>
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="modals" ID="Content3" runat="server">
</asp:Content>
