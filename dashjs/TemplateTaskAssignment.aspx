<%@ Page Title="" Language="C#" MasterPageFile="~/MasterNewUI.Master" AutoEventWireup="true" CodeBehind="TemplateTaskAssignment.aspx.cs" Inherits="ManageUPPRM.dashjs.TemplateTaskAssignment" %>

<%@ Import Namespace="ManageUPPRM.Extensions" %>

<%@ Register TagPrefix="uc" TagName="RepeatSchedule" Src="~/UserControls/RepeatSchedule.ascx" %>
<%@ Register TagPrefix="uc" TagName="UsersGroup" Src="~/UserControls/UsersGroup.ascx" %>
<%@ Register TagPrefix="uc" TagName="TaskComments" Src="~/UserControls/TaskComments.ascx" %>
<%@ Register TagPrefix="uc" TagName="UsersGroupModal" Src="~/UserControls/UsersGroupModal.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="<%= Page.ContentLastWrite("/dashjs/js/fuelUx/scheduler.js")%>"></script>
    <script>
        $(document).ready(function () {
            InitializeDirtyStates();

            //General Due Date
            $('.general-duedate-calendar')
                .datepicker({ todayHighlight: true, startDate: new Date() })
                .on('changeDate', function (e) {
                    bootbox.dialog({
                        message: "Do you want to set this date on every action item? (If you choose Smart Update it will only update dates that are not manually set)",
                        title: "Set Due Date",
                        buttons: {
                            danger: {
                                label: "None",
                                className: "btn-danger",
                                callback: function () {
                                }
                            },
                            success: {
                                label: "Smart Update",
                                className: "btn-success",
                                callback: function () {
                                    $('.action-items-container input.calendar').not('.dirty').each(function (index, calendar) {
                                        $(calendar).datepicker('setDate', e.date).removeClass('dirty');
                                        $(calendar).siblings(".dirty-info").hide();
                                        $(calendar).siblings(".duedate-manually-set").val(false);
                                    });
                                }
                            },
                            main: {
                                label: "Everything",
                                className: "btn-primary",
                                callback: function () {
                                    $('.action-items-container input.calendar').each(function (index, calendar) {
                                        $(calendar).datepicker('setDate', e.date).removeClass('dirty');
                                        $(calendar).siblings(".dirty-info").hide();
                                        $(calendar).siblings(".duedate-manually-set").val(false);
                                    });
                                }
                            }
                        }
                    });
                });

            //Action Items Due Dates
            $('.action-items-container input.calendar')
                .datepicker({ todayHighlight: true, startDate: new Date() })
                .on('changeDate', function (e) {
                    $(this).addClass('dirty');
                    $(this).siblings(".dirty-info").show();
                    $(this).siblings(".duedate-manually-set").val(true);
                })
                .on('clearDate', function (e) {
                    $(this).removeClass('dirty');
                    $(this).siblings(".dirty-info").hide();
                    $(this).siblings(".duedate-manually-set").val(false);
                });;


            //General Users
            $(".assignees .selected-users").on("change", function () {
                if ($(this).siblings(".status").val() != "loadComplete") {
                    return;
                }

                var selectedUsers = $(this).val();

                bootbox.dialog({
                    message: "Do you want to set these assignees on every action item? (If you choose Smart Update it will only update assignees that are not manually set)",
                    title: "Set Assignees",
                    buttons: {
                        danger: {
                            label: "None",
                            className: "btn-danger",
                            callback: function () {
                            }
                        },
                        success: {
                            label: "Smart Update",
                            className: "btn-success",
                            callback: function () {
                                $('.action-item .user-group-container').not('.dirty').each(function (index, userGroupContainer) {
                                    $(userGroupContainer).find(".selected-users").val(selectedUsers).trigger('change');;
                                    $(userGroupContainer).removeClass('dirty');
                                    $(userGroupContainer).closest(".action-item").find(".dirty-info-assignees").hide();
                                    $(userGroupContainer).closest('.action-item').find('.action-item-assignees-manually-set').val(false);
                                });
                            }
                        },
                        main: {
                            label: "Everything",
                            className: "btn-primary",
                            callback: function () {
                                $('.action-item .user-group-container').each(function (index, userGroupContainer) {
                                    $(userGroupContainer).find(".selected-users").val(selectedUsers).trigger('change');;
                                    $(userGroupContainer).removeClass('dirty');
                                    $(userGroupContainer).closest(".action-item").find(".dirty-info-assignees").hide();
                                    $(userGroupContainer).closest('.action-item').find('.action-item-assignees-manually-set').val(false);
                                });
                            }
                        }
                    }
                });
            })

            //Action Items Users
            $(".action-item .selected-users").on("change", function () {
                if ($(this).siblings(".status").val() != "loadComplete") {
                    return;
                }

                var value = $(this).val();

                if (value) {
                    $(this).closest('.user-group-container').addClass('dirty');
                    $(this).closest('.action-item').find('.dirty-info-assignees').show();
                    $(this).closest('.action-item').find('.action-item-assignees-manually-set').val(true);
                } else {
                    $(this).closest('.user-group-container').removeClass('dirty');
                    $(this).closest('.action-item').find('.dirty-info-assignees').hide();
                    $(this).closest('.action-item').find('.action-item-assignees-manually-set').val(false);
                }
            });

            $('.scheduler-repeat').scheduler();

            $("#AssignTemplateTask").click(function () {
                var selectedUsers = [];

                $('.action-items-container .selected-users, .assignees .selected-users').each(function (idx) {
                    var actionItemSelectedUsers = $(this).val().split(',');
                    $.each(actionItemSelectedUsers, function (idx, val) {
                        if ($.inArray(val, selectedUsers) == -1 && val != "") {
                            selectedUsers.push(val);
                        }
                    });
                });

                var data = {
                    userIDs: selectedUsers,
                    templateTaskID: '<%=this.TemplateTaskID%>'
                };

                call(resolveHost() + "/ManageUPWebService.asmx/CheckIfUsersAlreadyHaveTemplateTaskAssigned", JSON.stringify(data), function (response) {
                    var users = response.d;

                    if (users.length > 0) {
                        //Build comma separated string for user names
                        var usersText = users.join(", ");
                        var pos = usersText.lastIndexOf(",");
                        if (pos > 0) {
                            usersText = usersText.substring(0, pos) + " and" + usersText.substring(pos + 1);
                        };

                        bootbox.confirm("The template task <b>'<%=this.TemplateTask.TaskName%>'</b> is already assigned for <b>" + usersText + "</b>. Do you want to reassign?", function (result) {
                            if (result) {
                                $("#<%=this.Assign.ClientID%>").click();
                            }
                        });
                    } else {
                        $("#<%=this.Assign.ClientID%>").click();
                    }
                });

            });
        });

        var InitializeDirtyStates = function () {
            //Dirty Due Dates
            $(".duedate-manually-set[value='true']").each(function (index) {
                $(this).siblings("input.calendar").addClass('dirty');
                $(this).siblings(".dirty-info").show();
            });

            //Dirty Action Items Assignees
            $(".action-item-assignees-manually-set[value='true']").each(function (index) {
                $(this).closest('.action-item').find('.dirty-info-assignees').show();
                $(this).closest('.action-item').find('.user-group-container').addClass('dirty');
            });
        }
    </script>

    <style>
        .dirty {
            border-color: #E9C766;
            outline: 0;
            -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075),0 0 8px rgba(233, 205, 102, 0.6);
            box-shadow: inset 0 1px 1px rgba(0,0,0,.075),0 0 8px rgba(233, 205, 102, 0.6);
        }
        .bootbox.modal {
            z-index: 2147483647 !important; /*Fixes date picker overlay*/
        }
        .action-item {
            margin-top: 10px;
        }
        .action-item-title {
            margin-top: 10px;
        }
        .dirty-info {
            top: -10%;
            right: -4%;
            color: #E9C766 !important;
        }
        .user-group-container.dirty .selected-descriptions {
	        border-top: 1px solid #E9C766;
	        border-right: 1px solid #E9C766;
	        border-bottom: 1px solid #E9C766;
        }

        .user-group-container.dirty .input-group-addon {
	        border-top: 1px solid #E9C766;
	        border-left: 1px solid #E9C766;
	        border-bottom: 1px solid #E9C766;
        }
        .info {
            margin-top:2%;
        }
        .action-items-container {
            margin-bottom: 20px;
        }
        .action-item-divider {
            margin-top: 10px;
            margin-bottom: 10px;
        }
    </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-content-wrapper">
        <div class="page-content">
            <div class="row">
                <div class="col-md-12">
                    
                    <h3 class="page-title">Template Objective Assignment: <%= this.TemplateTask.TaskName %></h3>
                    
                    <div class="page-bar">
                        <ul class="page-breadcrumb">
                            <li class="ms-hover">
                                <i class="fa fa-home"></i>
                                <a href="/dashjs/dashboardjsnew.aspx">Dashboard</a>
                                <i class="fa fa-angle-right"></i>
                                <a href="/dashjs/TemplateTasks.aspx">Template Objectives</a>
                                <i class="fa fa-angle-right"></i>
                                <a href="/dashjs/ViewdTask.aspx?TemplateTaskID=<%=this.TemplateTaskID.HasValue ? this.TemplateTaskID.Value.ToString() : "" %>">Template Objective Details</a>
                                <i class="fa fa-angle-right"></i>
                            </li>
                            <li class="ms-hover">
                                <a href="#">Template Objective Assignment</a>
                            </li>
                        </ul>
                    </div>

                    <div class="portlet light bordered">
                        <div class="portlet-body">

                            <div class="form">
                                <div class="form-body">
                                    <div id="GeneralInformationContainer" runat="server">
                                        <h3 class="form-section">General Information</h3>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="control-label col-md-3">Subject</label>
                                                    <div class="col-md-9 viewers">
                                                        <input type="text" class="text-input form-control" runat="server" id="NameEditable" />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <h3 class="form-section">Assignees</h3>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="control-label col-md-3">Assign To</label>
                                                <div class="col-md-9 assignees">
                                                    <uc:UsersGroup runat="server" ID="AssignTo" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="control-label col-md-3">Assigned By</label>
                                                <div class="col-md-9">
                                                    <select runat="server" id="AssignedBy" class="form-control" multiple="false"></select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="control-label col-md-3">Task Viewers</label>
                                                <div class="col-md-9 viewers">
                                                    <uc:UsersGroup runat="server" ID="Viewers" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="control-label col-md-3">Backup Owners</label>
                                                <div class="col-md-9 backup-owners">
                                                    <uc:UsersGroup runat="server" ID="BackupOwners" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="row" id="ApproverContainer" runat="server">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="control-label col-md-3">Approver</label>
                                                <div class="col-md-9">
                                                    <select runat="server" id="Approver" class="form-control"></select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="control-label col-md-4">Add to Transparency Chart</label>
                                                <div class="col-md-6" style="margin-top: 9px;">
                                                    <input type="checkbox" name="addToChart" class="addToChart" checked="checked" runat="server" id="AddToChart" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <h3 class="form-section">Dates</h3>
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label class="control-label col-md-5">Due Date</label>
                                                <div class="col-md-7">
                                                    <input type="text" class="text-input datepicker calendar input-small form-control general-duedate-calendar" runat="server" id="DueDate" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label class="control-label col-md-5">Head's Up days</label>
                                                <div class="col-md-3">
                                                    <input type="text" runat="server" id="HeadsUp" class="text-input input-xsmall validate[custom[onlyNumber]] headsup form-control" />
                                                </div>
                                                <i class="fa fa-info-circle withTooltip info" data-original-title="Represents the amount of days before the Due Date from which a Task will become 'Due Soon'"></i>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label class="control-label col-md-6">Urgent days</label>
                                                <div class="col-md-3">
                                                    <input type="text" runat="server" id="Urgent" class="text-input input-xsmall validate[custom[onlyNumber]] urgent form-control" />
                                                </div>
                                                <i class="fa fa-info-circle withTooltip info" data-original-title="Represents the amount of days before the Due Date from which a Task will become 'Urgent'"></i>
                                            </div>
                                        </div>
                                    </div>
                                    <h4 class="form-section">Recurrence</h4>
                                    <div class="row">
                                        <div class="col-md-12 pull-left">
                                            <uc:RepeatSchedule ID="RepeatSchedule" runat="server" />
                                        </div>
                                    </div>
                                    <div class="row" id="ActionItemsContainer" runat="server">
                                        <h3 class="form-section">Action Items</h3>
                                        <div class="col-md-12">
                                            <div class="row">
                                                <div class="col-md-3"><b>Name</b></div>
                                                <div class="col-md-6"><b>Assign To</b></div>
                                                <div class="col-md-3"><b>Due Date</b></div>
                                            </div>
                                            <div class="action-items-container" runat="server">
                                                <%--ACTION ITEMS LEVEL--%>
                                                <asp:Repeater ID="ActionItemRepeater" runat="server">
                                                    <ItemTemplate>
                                                        <div class="action-item">
                                                            <div class="row">
                                                                <span class="action-item-title col-md-3"><%# Eval("TaskName") %></span>
                                                                <div class="col-md-5 input-icon">
                                                                    <uc:UsersGroup runat="server" ID="actionItemAssignees" />
                                                                    <i class="fa fa-info-circle dirty-info dirty-info-assignees withTooltip" style="display: none; margin-right: 12px;" data-original-title="These assignees were set manually"></i>
                                                                </div>
                                                                <input type="hidden" class="action-item-assignees-manually-set" runat="server" value="false" />
                                                                <div class="col-md-3 col-md-offset-1 input-icon input-medium">
                                                                    <i class="fa fa-calendar input-icon" style="margin-top: 10px;"></i>
                                                                    <input type="text" class="form-control calendar" runat="server" id="actionItemDueDate"/>
                                                                    <i class="fa fa-info-circle dirty-info withTooltip" style="display: none;" data-original-title="This date was set manually"></i>
                                                                    <input type="hidden" class="duedate-manually-set" runat="server" value="false" />
                                                                </div>
                                                                <input type="hidden" id="actionItemID" value='<%# Eval("TemplateTaskID") %>' runat="server" />
                                                                <input type="hidden" id="actionItemName" value='<%# Eval("TaskName") %>' runat="server" />
                                                            </div>
                                                        </div>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                                <%--/ACTION ITEMS LEVEL--%>
                                            </div>
                                        </div>
                                    </div>
                                    <uc:TaskComments ShowAddCommentButton="false" Collapsed="false" runat="server" ID="TaskComments" DisableReactions="true"></uc:TaskComments>
                                    
                                    <div class="row">
                                        <div class="col-md-2">
                                            <a class="btn red" href="/dashjs/ViewdTask.aspx?TemplateTaskID=<%=this.TemplateTaskID.HasValue ? this.TemplateTaskID.Value.ToString() : "" %>">Cancel</a>
                                            <input type="button" class="btn green" value="Assign" id="AssignTemplateTask" />
                                            <asp:Button Text="Assign" runat="server" CssClass="btn green" OnClick="Assign_Click" style="display:none;" ID="Assign"/>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="modals" runat="server">
    <uc:UsersGroupModal ID="UsersGroupModal" runat="server" />
</asp:Content>
