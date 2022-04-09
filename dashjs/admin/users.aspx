<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="Static" MasterPageFile="~/MasterNewUi.Master" CodeBehind="users.aspx.cs" Inherits="ManageUPPRM.users" EnableEventValidation="false" EnableViewStateMac="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../../admin/admin.js"></script>
    <script src="../js/users.js"></script>

    <script type="text/javascript">

        function doOpenUser() {
            $('#user-modal').modal('show');
            return false;
        };

        //roles
        function EditRole(roleid, clientid) {
            $("#RoleIDHidden").val(roleid);
            var DTO = { 'ClientID': clientid };

            $.ajax({
                type: "POST",
                url: "../../dashjs/admin/users.aspx/GetDepartments",
                data: JSON.stringify(DTO),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    $("#DepartmentListDropDown").html(data.d);

                    DTO = { 'RoleID': roleid };

                    $.ajax({
                        type: "POST",
                        url: "../../admin/AdminService.asmx/GetRole",
                        async: true,
                        data: JSON.stringify(DTO),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (data) {
                            $("#RoleName").val(data.d["RoleName"]);
                            $("#RoleDesc").val(data.d["RoleDescription"]);
                            $("#DepartmentListDropDown").val(data.d["DepartmentID"]);
                            $("#roles-modal").modal('show');
                        }
                    });
                }
            });
        }

        function UpdateUserTitle() {
            DTO = { 'RoleID': $("#RoleIDHidden").val(), 'RoleName': $("#RoleName").val(), 'RoleDesc': $("#RoleDesc").val(), 'DepartmentID': $("#DepartmentListDropDown").val() };

            $.ajax({
                type: "POST",
                url: "../../admin/AdminService.asmx/UpdateRole",
                data: JSON.stringify(DTO),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    if (data.d === 1) {
                        $("#roles-modal").modal('hide');
                        location.reload();
                    }
                    else {
                        alert('Role was not updated. Check the name. The Role Name cannot be repeated');
                    }
                }
            });
        }

        function ShowAddRole() {
            var DTO = { 'ClientID': getCurrentClientID() };

            $.ajax({
                type: "POST",
                async: true,
                url: "../../dashjs/admin/users.aspx/GetDepartments",
                data: JSON.stringify(DTO),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    $("#NewDepartmentListDropDown").html(data.d);
                    $("#addroles-modal").modal('show');
                }
            });
        }

        function AddRole() {
            DTO = { 'RoleName': $("#NewRoleName").val(), 'RoleDesc': $("#NewRoleDesc").val(), 'DepartmentID': $("#NewDepartmentListDropDown").val() };

            $.ajax({
                type: "POST",
                url: "../../admin/AdminService.asmx/AddRole",
                async: true,
                data: JSON.stringify(DTO),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    if (data.d != 0) {
                        $("#addroles-modal").modal('hide');
                        location.reload();
                    }
                    else {
                        alert('Role was not created. Check the name. The Role Name cannot be repeated');
                    }

                }
            });
        }

        function RemoveClientList() {
            $("#ClientListContainer").html('');
        }

        function ArchiveOrUnarchiveOperationalRole(roleId) {
            DTO = { 'roleId': roleId };
            url = "users.aspx/ArchiveOrUnarchiveOperationalRole";
            success = function (data) {
                Metronic.blockUI();
                location.reload();
            }

            call(url, JSON.stringify(DTO), success);
        }

        function ArchiveOrUnarchiveFunctionalRole(roleId) {
            DTO = { 'roleId': roleId };
            url = "users.aspx/ArchiveOrUnarchiveFunctionalRole";
            success = function (data) {
                Metronic.blockUI();
                location.reload();
            }

            call(url, JSON.stringify(DTO), success);
        }

        var getCurrentClientID = function() {
            if ($('#ClientList').length) {
                return $('#ClientList option:selected').val();
            }
            else {
                return $('#clientId').val();
            };
        };

        <%if (true)
        {%>
            $(function () {
                $("body").on('click', ".login-as-user", function () {
                    var userID = $(this).data('userId');

                    bootbox.confirm("You are going to be logged out and log in as this user, are you sure you want to proceed?", function (result) {
                        call('/ManageUPWebService.asmx/LoginAsUser', JSON.stringify({ userID: userID }), function (response) {
                            var result = response.d;
                            $('#error-msg').html('');

                            if (!result.Success) {
                                showErrorMsgs($('#error-msg'), result.Errors);
                            } else {
                                window.location = '/dashjs/dashboardjsNew.aspx'
                            }
                        });
                    });
                });
            });
        <%}%>
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <input type="hidden" id="selectedClient" runat="server" />
    <input type="hidden" id="adminUserCreation" runat="server" />
    <input type="hidden" id="successMsj" runat="server" />


    <div class="page-content-wrapper">
        <div class="page-content">

            <div class="portlet light bordered" data-team="false">
                <div class="portlet-title " style="border: none;">
                    <div class="tabbable-line col-md-9">
                        <ul class="nav nav-tabs home-tabs nav-justified task-widget" id="AdminTabs">
                            <asp:Literal ID="AdminMenu" runat="server" />
                        </ul>
                    </div>
                </div>
            </div>
            <div class="tab-content">
                <div class="tab-pane active" id="tab0">
                    <div class="row">
                        <div id="success-msg" class="alert alert-success span12" style="display: none;">
                        </div>
                        <div class="col-md-12">
                            <div id="error-msg">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6" id="clients-container">
                            <asp:DropDownList ID="ClientList" runat="server" CssClass="form-control" AppendDataBoundItems="true">
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="row margin-top-20" id="List">
                        <div class="col-md-12">
                            <div class="portlet box grey-silver">
                                <div class="portlet-title">
                                    <div class="caption withTooltip" data-title="Users include Names, Email, Departments and Last Login of the people that have access to the system">
                                        Users
                                    </div>
                                    <div class="actions">
                                        <a class="btn green tooltips" id="create-user" href="javascript:;">Create&nbsp;
                                            <i class="fa fa-plus"></i>
                                        </a>
                                    </div>
                                </div>
                                <div class="portlet-body">
                                    <asp:CheckBox ID="chkInactiveUsers" AutoPostBack="true" runat="server" Text="Include inactive users" />
                                    <asp:Literal ID="UserList" runat="server"></asp:Literal>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row" id="ListRoles">
                        <div class="col-md-12">
                            <div class="portlet box grey-silver">
                                <div class="portlet-title">
                                    <div class="caption withTooltip" data-title="Operational Roles are administrative titles such as Director, Staff, and Executive">
                                        Operational Roles
                                    </div>
                                    <div class="actions">
                                        <a class="btn green tooltips" id="create-role" href='javascript:void(0)' onclick="ShowAddRole();">Create &nbsp;
                                            <i class="fa fa-plus"></i>
                                        </a>
                                    </div>
                                </div>
                                <div class="portlet-body">
                                    <asp:CheckBox ID="chkArchivedOperationalRoles" AutoPostBack="true" runat="server" Text="Include archived roles" />
                                    <asp:Literal ID="OperationalRolesList" runat="server"></asp:Literal>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row" id="ListFunctionalRoles">
                        <div class="col-md-12">
                            <div class="portlet box grey-silver">
                                <div class="portlet-title">
                                    <div class="caption withTooltip" data-title="Functional Roles are job descriptions such Nurse, Therapist, and MD">
                                        Functional Roles
                                    </div>
                                    <div class="actions">
                                        <a class="btn green tooltips" id="create-operational-role" href='javascript:void(0)' onclick="showFunctionalRoleModal();">Create &nbsp;
                                            <i class="fa fa-plus"></i>
                                        </a>
                                    </div>
                                </div>
                                <div class="portlet-body">
                                    <asp:CheckBox ID="chkArchivedFunctionalRoles" AutoPostBack="true" runat="server" Text="Include archived roles" />
                                    <asp:Literal ID="FunctionalRolesTable" runat="server"></asp:Literal>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ContentPlaceHolderID="modals" ID="Content3" runat="server">
    <div id="user-modal" class="modal fade" tabindex="-1" aria-hidden="true" style="display: none;">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">New User</h2>
                </div>
                <div class="modal-body">
                    <div class="form" role="form">
                        <div class="form-body">
                            <input type="hidden" name="userId" id="userId" />
                            <div class="alert alert-error" style="display: none;">
                            </div>

                            <div class="form-group">
                                <label class="control-label col-md-3" for="fname">User Name</label>
                                <div class="col-md-9">
                                    <input name="username" type="text" class="reset-input form-control" />
                                    <label class="help-inline" id="username-error" style="display: none">The 'User Name' is duplicated</label>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-md-3" for="fname">First Name</label>
                                <div class="col-md-9">
                                    <input name="fname" type="text" class="reset-input form-control" />
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-md-3" for="lname">Last Name</label>
                                <div class="col-md-9">
                                    <input name="lname" type="text" class="reset-input form-control" />
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-md-3" for="email">Email</label>
                                <div class="col-md-9">
                                    <input name="email" type="text" class="reset-input form-control" />
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-md-3" for="telephone">Telephone</label>
                                <div class="col-md-9">
                                    <input name="telephone" type="text" class="reset-input form-control" />
                                </div>
                            </div>

                            <input type="hidden" name="clientId" id="clientId" />

                            <div class="form-group" id="client-label-container">
                                <label class="control-label col-md-3" for="client">Client</label>
                                <div class="col-md-9">
                                    <label class="client-name control-label "></label>
                                </div>
                            </div>

                            <div class="form-group" id="department-container">
                                <label class="control-label col-md-3" for="department">Department</label>
                                <div class="col-md-9">
                                    <select name="departments" id="departments" class="reset-input form-control"></select>
                                </div>
                                <input type="hidden" name="departmentid" id="departmentid" />
                            </div>

                            <div class="form-group">
                                <label class="control-label col-md-3" for="address1">Address Line 1</label>
                                <div class="col-md-9">
                                    <input name="address1" type="text" class="reset-input form-control" />
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-md-3" for="address2">Address Line 2</label>
                                <div class="col-md-9">
                                    <input name="address2" type="text" class="reset-input form-control" />
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-md-3" for="city">City</label>
                                <div class="col-md-9">
                                    <input name="city" type="text" class="reset-input form-control">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-md-3" for="stateId">State</label>
                                <div class="col-md-9">
                                    <asp:DropDownList ID="USState" runat="server" CssClass="reset-input form-control" AppendDataBoundItems="true" ClientIDMode="Static">
                                    </asp:DropDownList>
                                </div>
                                <input type="hidden" name="stateId" id="stateId" />
                            </div>

                            <div class="form-group">
                                <label for="zipcode" class="control-label col-md-3">Zip Code</label>
                                <div class="col-md-9 controls-row">
                                    <input type="text" name="zipcode" class="reset-input form-control" />
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-md-3" for="statusId">Account Status</label>
                                <div class="col-md-9">
                                    <asp:DropDownList ID="Status" runat="server" CssClass="reset-input form-control" AppendDataBoundItems="true" ClientIDMode="Static">
                                        <asp:ListItem Text="Active" Value="true"></asp:ListItem>
                                        <asp:ListItem Text="Inactive" Value="false"></asp:ListItem>
                                    </asp:DropDownList>
                                    <input type="hidden" name="statusId" id="statusId" />
                                </div>
                            </div>

                            <!-- Select Basic -->
                            <div class="form-group">
                                <label class="control-label col-md-3" for="systemrole">System Role</label>
                                <div class="col-md-9">
                                    <asp:DropDownList ID="systemrole" runat="server" CssClass="reset-input form-control" AppendDataBoundItems="true" ClientIDMode="Static">
                                    </asp:DropDownList>
                                    <input type="hidden" name="systemroleId" id="systemroleId" />
                                </div>
                            </div>

                            <!-- Select Basic -->
                            <div class="form-group">
                                <label class="control-label col-md-3" for="systemrole">Operational Role</label>
                                <div class="col-md-9">
                                    <asp:DropDownList ID="cmbUserTitles" runat="server" CssClass="reset-input form-control" AppendDataBoundItems="true" ClientIDMode="Static">
                                    </asp:DropDownList>
                                    <input type="hidden" name="userTitleId" id="userTitleId" />
                                </div>
                            </div>

                            <!-- Select Basic -->
                            <div class="form-group">
                                <label class="control-label col-md-3" for="cmbClientTitles">Functional Role</label>
                                <div class="col-md-9">
                                    <asp:DropDownList ID="cmbClientTitles" runat="server" CssClass="reset-input form-control" AppendDataBoundItems="true" ClientIDMode="Static">
                                    </asp:DropDownList>
                                    <input type="hidden" name="clientTitleId" id="clientTitleId" />
                                </div>
                            </div>


                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <input type="button" class="btn green" id="save-user" value="Save" />
                    <input type="button" class="btn red" data-dismiss="modal" onclick="resetForm()" value="Cancel" />
                </div>
            </div>
        </div>
    </div>

    <div id="roles-modal" class="modal fade" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">

                <div class="modal-header">
                    <h2>Edit Role</h2>
                    <input type="hidden" id="RoleIDHidden" />
                </div>
                <div class="modal-body">
                    <div class="form-horizontal fuelux no-left-margin label-large" role="form">
                        <input type="hidden" name="clientId" id="clientId" />
                        <div class="alert alert-error" style="display: none;">
                        </div>

                        <div class="form-group">
                            <label class="control-label col-md-3" for="name">Name</label>
                            <div class="col-md-9">
                                <input name="name" id="RoleName" type="text" class="reset-input form-control" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-md-3" for="description">Description</label>
                            <div class="col-md-9">
                                <input name="description" id="RoleDesc" type="text" class="reset-input form-control" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-md-3" for="description">Department</label>
                            <div class="col-md-9">
                                <select id="DepartmentListDropDown" class="form-control"></select>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <input type="button" class="btn green" id="save-department" value="Save" onclick="UpdateUserTitle();" />
                    <a href='javascript:void(0)' class="btn btn-danger" data-dismiss="modal" onclick="resetForm()">Cancel</a>
                </div>
            </div>
        </div>
    </div>

    <div id="addroles-modal" class="modal fade" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">

                <div class="modal-header">
                    <h2>Create Role</h2>
                </div>
                <div class="modal-body">
                    <div class="form-horizontal fuelux no-left-margin label-large" role="form">
                        <div class="alert alert-error" style="display: none;">
                        </div>

                        <div class="form-group">
                            <label class="control-label col-md-3" for="name">Name</label>
                            <div class="col-md-9">
                                <input name="name" id="NewRoleName" type="text" class="reset-input form-control" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-md-3" for="description">Description</label>
                            <div class="col-md-9">
                                <input name="description" id="NewRoleDesc" type="text" class="reset-input form-control" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-md-3" for="description">Department</label>
                            <div class="col-md-9">
                                <select id="NewDepartmentListDropDown" class="form-control"></select>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <input type="button" class="btn green" id="add-role" value="Save" onclick="AddRole();" />
                    <a href='javascript:void(0)' class="btn btn-danger" data-dismiss="modal" onclick="resetForm()">Cancel</a>
                </div>
            </div>
        </div>
    </div>

    <div id="functional-role-modal" class="modal fade" tabindex="-1" aria-hidden="true" style="display: none;">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Functional Role</h3>
                </div>
                <div class="modal-body">
                    <div class="form">
                        <div class="form-horizontal" role="form">
                            <div class="alert alert-error" style="display: none;">
                            </div>
                            <input hidden="hidden" name="functionalRoleID" id="functionalRoleID" />
                            <div class="form-group">
                                <label class="control-label col-md-3" for="name">Name</label>
                                <div class="col-md-9">
                                    <input name="funcionalRoleName" id="funcionalRoleName" type="text" class="form-control" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <input type="button" class="btn green" id="add-functional-role" value="Save" onclick="saveFunctionalRole();" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
