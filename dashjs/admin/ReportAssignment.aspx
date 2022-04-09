<%@ Page Title="" Language="C#" MasterPageFile="~/MasterNewUI.Master" AutoEventWireup="true" CodeBehind="ReportAssignment.aspx.cs" Inherits="ManageUPPRM.dashjs.admin.ReportAssignment" %>

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
                        message: "Do you want to set this date on every task and action item? (If you choose Smart Update it will only update dates that are not manually set)",
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
                                    $('.sections input.calendar').not('.dirty').each(function (index, calendar) {
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
                                    $('.sections input.calendar').each(function (index, calendar) {
                                        $(calendar).datepicker('setDate', e.date).removeClass('dirty');
                                        $(calendar).siblings(".dirty-info").hide();
                                        $(calendar).siblings(".duedate-manually-set").val(false);
                                    });
                                }
                            }
                        }
                    });
                });

            //Tasks and Action Items Due Dates
            $('.sections input.calendar')
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
                    message: "Do you want to set these assignees on every task and action item? (If you choose Smart Update it will only update assignees that are not manually set)",
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
                                $('.parent-task-container .user-group-container').not('.dirty').each(function (index, userGroupContainer) {
                                    $(userGroupContainer).find(".selected-users").val(selectedUsers).trigger('change');;
                                    $(userGroupContainer).removeClass('dirty');
                                    $(userGroupContainer).closest(".parent-task-container").find(".dirty-info-parent-task").hide();
                                    $(userGroupContainer).closest('.parent-task-container').find('.parent-task-assignees-manually-set').val(false);
                                });
                                $('.child-task .user-group-container').not('.dirty').each(function (index, userGroupContainer) {
                                    $(userGroupContainer).find(".selected-users").val(selectedUsers).trigger('change');;
                                    $(userGroupContainer).removeClass('dirty');
                                    $(userGroupContainer).closest(".child-task").find(".dirty-info-child-task").hide();
                                    $(userGroupContainer).closest('.child-task').find('.child-task-assignees-manually-set').val(false);
                                });
                            }
                        },
                        main: {
                            label: "Everything",
                            className: "btn-primary",
                            callback: function () {
                                $('.parent-task-container .user-group-container').each(function (index, userGroupContainer) {
                                    $(userGroupContainer).find(".selected-users").val(selectedUsers).trigger('change');;
                                    $(userGroupContainer).removeClass('dirty');
                                    $(userGroupContainer).closest(".parent-task-container").find(".dirty-info-parent-task").hide();
                                    $(userGroupContainer).closest('.parent-task-container').find('.parent-task-assignees-manually-set').val(false);
                                });
                                $('.child-task .user-group-container').each(function (index, userGroupContainer) {
                                    $(userGroupContainer).find(".selected-users").val(selectedUsers).trigger('change');;
                                    $(userGroupContainer).removeClass('dirty');
                                    $(userGroupContainer).closest(".child-task").find(".dirty-info-child-task").hide();
                                    $(userGroupContainer).closest('.child-task').find('.child-task-assignees-manually-set').val(false);
                                });
                            }
                        }
                    }
                });
            })

            //Parent Task Users
            $(".parent-task .selected-users").on("change", function () {
                if ($(this).siblings(".status").val() != "loadComplete") {
                    return;
                }

                var value = $(this).val();

                if (value) {
                    $(this).closest('.user-group-container').addClass('dirty');
                    $(this).closest('.parent-task-container').find('.dirty-info-parent-task').show();
                    $(this).closest('.parent-task-container').find('.parent-task-assignees-manually-set').val(true);
                } else {
                    $(this).closest('.user-group-container').removeClass('dirty');
                    $(this).closest('.parent-task-container').find('.dirty-info-parent-task').hide();
                    $(this).closest('.parent-task-container').find('.parent-task-assignees-manually-set').val(false);
                }
            });

            //Child Task Users
            $(".child-task .selected-users").on("change", function () {
                if ($(this).siblings(".status").val() != "loadComplete") {
                    return;
                }

                var value = $(this).val();

                if (value) {
                    $(this).closest('.user-group-container').addClass('dirty');
                    $(this).closest('.child-task').find('.dirty-info-child-task').show();
                    $(this).closest('.child-task').find('.child-task-assignees-manually-set').val(true);
                } else {
                    $(this).closest('.user-group-container').removeClass('dirty');
                    $(this).closest('.child-task').find('.dirty-info-child-task').hide();
                    $(this).closest('.child-task').find('.child-task-assignees-manually-set').val(false);
                }
            });
            
            $('.scheduler-repeat').scheduler();
            showWarningMsg('The templates that are already assigned are going to be reassigned.', '', $('.portlet-assignment'));
        });

        var InitializeDirtyStates = function () {
            //Dirty Due Dates
            $(".duedate-manually-set[value='true']").each(function (index) {
                $(this).siblings("input.calendar").addClass('dirty');
                $(this).siblings(".dirty-info").show();
            });

            //Dirty Child Task Assignees
            $(".child-task-assignees-manually-set[value='true']").each(function (index) {
                $(this).closest('.child-task').find('.dirty-info-child-task').show();
                $(this).closest('.child-task').find('.user-group-container').addClass('dirty');
            });

            //Dirty Parent Task Assignees
            $(".parent-task-assignees-manually-set[value='true']").each(function (index) {
                $(this).closest('.parent-task-container').find('.dirty-info-parent-task').show();
                $(this).closest('.parent-task-container').find('.user-group-container').addClass('dirty');
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
        .dirty-info {
            top: -20%;
            right: -4%;
            color: #E9C766 !important;
        }
        .bootbox.modal {
            z-index: 2147483647 !important; /*Fixes date picker overlay*/
        }
        .section-portlet-title {
            line-height: 60px !important;
            padding-top: 15px;
            background-color: beige;
            font-size: 16px;
            text-transform: uppercase;
            font-weight: 600;
            margin-bottom: 10px !important;
        }
        .section-portlet-title caption {
            padding-top: 19px;
        }
        .parent-task {
            margin-top: 5px;
        }
        .parent-task-container {
            font-weight: bold;
            padding-left: 28px;
        }
        .parent-task-title-text {
            margin-top: 7px;
        }
        .parent-task > hr{
            margin-top: 5px;
            margin-bottom: 13px;
        }
        .parent-task .calendar {
            margin-top: -5px;
        }
        .parent-task-calendar-container {
            margin-top: 5px;
            margin-bottom: 5px;
            margin-right: 15px;
        }
        .child-task {
            padding-left: 50px;
            margin-top: 10px;
        }
        .child-task-title {
            margin-top: 7px;
        }
        .child-task-calendar-container {
            margin-top: 5px;
            margin-bottom: 5px;
            margin-right: 30px;
        }
        .child-task .user-group-container {
            margin-left: -21px;
            margin-right: 18px;
        }
        .dirty-info-parent-task {
            margin-top: 10px;
            font-size: 16px;
            line-height: 12px;
            margin-left: -7px;
        }
        .dirty-info-child-task {
            margin-top: 10px;
            margin-left: -23px;
            font-size: 16px;
            line-height: 12px;
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
        .select2-input {
            width: auto !important;
        }
        .input-xsmall {
            max-width: 100%;
        }
    </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-content-wrapper">
        <div class="page-content">
            <div class="row">
                <div class="col-md-12">
                    
                    <h3 class="page-title">Report Assignment: <%=this.ReportTemplate.DocumentName %></h3>
                    
                    <div class="page-bar">
                        <ul class="page-breadcrumb">
                            <li class="ms-hover">
                                <i class="fa fa-home"></i>
                                <a href="/dashjs/dashboardjsnew.aspx">Dashboard</a>
                                <i class="fa fa-angle-right"></i>
                                <a href="/dashjs/admin/reportDocuments.aspx">Reports</a>
                                <i class="fa fa-angle-right"></i>
                                <a href="/dashjs/admin/ViewTemplateReport.aspx?ReportID=<%=this.ReportTemplateID.HasValue ? this.ReportTemplateID.Value.ToString() : "" %>">View</a>
                                <i class="fa fa-angle-right"></i>
                            </li>
                            <li class="ms-hover">
                                <a href="#">Report Assignment</a>
                            </li>
                        </ul>
                    </div>

                    <div class="portlet light bordered">
                        <div class="portlet-body portlet-assignment">

                            <div class="form">
                                <div class="form-body">
                                    <h3 class="form-section subtask-modal-content">Assignees</h3>

                                    <div class="row form-section" runat="server" id="NameContainer" visible="false">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="control-label col-md-3">Subject</label>
                                                <div class="col-md-9 viewers">
                                                    <input type="text" class="text-input nameEditable form-control" runat="server" id="NameEditable" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
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
                                                    <select runat="server" id="AssignedBy" class="assigner form-control" multiple="false"></select>
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

                                    <div class="row approver-content">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="control-label col-md-3">Approver</label>
                                                <div class="col-md-9">
                                                    <select runat="server" id="Approver" class="approver form-control"></select>
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

                                    <h3 class="form-section subtask-modal-content">Dates</h3>
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
                                    <h3 class="form-section">Tasks</h3>
                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="sections">

                                                <%--SECTION LEVEL--%>
                                                <asp:Repeater ID="SectionRepeater" runat="server">
                                                    <ItemTemplate>
                                                        <div>
                                                            <div class="portlet box">
                                                                <div class="portlet-title section-portlet-title">
                                                                    <div class="pull-left tools">
                                                                        <a href="javascript:;" class="collapse"></a>
                                                                    </div>
                                                                    <div class="caption" style="line-height: 60px; margin-left: 10px;">
                                                                        <span class="name-head"><%# Eval("Name") %></span>
                                                                        <span class="description-head"><%# Eval("Description") %></span>
                                                                    </div>
                                                                </div>
                                                                <div class="portlet-body">

                                                                        <%--PARENT TASKS LEVEL--%>
                                                                        <asp:Repeater ID="ParentTaskRepeater" runat="server">
                                                                            <ItemTemplate>
                                                                                <div class="parent-task">
                                                                                    <div class="row">
                                                                                        <div class="col-md-12 parent-task-container">
                                                                                            <asp:HiddenField ID="parentTaskID" runat="server"/>
                                                                                            <span class="col-md-3 parent-task-title-text" data-id="<%# Eval("TemplateTaskID") %>"><%# Eval("Name") %></span>
                                                                                            <div class="col-md-5">
                                                                                                <uc:UsersGroup runat="server" ID="parentTaskAssignees" class="asd"/>
                                                                                            </div>
                                                                                            <i class="fa fa-info-circle dirty-info dirty-info-parent-task withTooltip" style="display: none;" data-original-title="These assignees were set manually"></i>
                                                                                            <input type="hidden" class="parent-task-assignees-manually-set" runat="server" value="false" />
                                                                                            <div class="col-md-3 input-icon input-medium pull-right parent-task-calendar-container">
                                                                                                <i class="fa fa-calendar input-icon" style="margin-top: 5px;"></i>
                                                                                                <input type="text" class="form-control calendar parent-task-calendar" runat="server" id="parentTaskDueDate"/>
                                                                                                <i class="fa fa-info-circle dirty-info withTooltip" style="display: none;" data-original-title="This date was set manually"></i>
                                                                                                <input type="hidden" class="duedate-manually-set" runat="server" value="false" />
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>
                                                                                    <div class="row">
                                                                                        <div class="col-md-12">
                                                                                            <%--CHILD TASKS LEVEL--%>
                                                                                            <asp:Repeater ID="ChildTaskRepeater" runat="server">
                                                                                                <ItemTemplate>
                                                                                                    <div class="child-task">
                                                                                                        <div class="row">
                                                                                                            <asp:HiddenField ID="childTaskID" runat="server"/>
                                                                                                            <span class="child-task-title col-md-3"><%# Eval("Name") %></span>
                                                                                                            <div class="col-md-5">
                                                                                                                <uc:UsersGroup runat="server" ID="childTaskAssignees" />
                                                                                                            </div>
                                                                                                            <i class="fa fa-info-circle dirty-info dirty-info-child-task withTooltip" style="display: none;" data-original-title="These assignees were set manually"></i>
                                                                                                            <input type="hidden" class="child-task-assignees-manually-set" runat="server" value="false" />
                                                                                                            <div class="col-md-3 input-icon input-medium child-task-calendar-container pull-right">
                                                                                                                <i class="fa fa-calendar input-icon" style="margin-top: 5px;"></i>
                                                                                                                <input type="text" class="form-control calendar child-task-calendar" runat="server" id="childTaskDueDate"/>
                                                                                                                <i class="fa fa-info-circle dirty-info withTooltip" style="display: none;" data-original-title="This date was set manually"></i>
                                                                                                                <input type="hidden" class="duedate-manually-set" runat="server" value="false" />
                                                                                                            </div>
                                                                                                        </div>
                                                                                                    </div>
                                                                                                </ItemTemplate>
                                                                                            </asp:Repeater>
                                                                                            <%--/CHILD TASKS LEVEL--%>
                                                                                        </div>
                                                                                    </div>
                                                                                    <hr />
                                                                                </div>
                                                                            </ItemTemplate>
                                                                        </asp:Repeater>
                                                                        <%--/PARENT TASKS LEVEL--%>

                                                                </div>
                                                            </div>
                                                        </div>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                                <%--/SECTION LEVEL--%>

                                            </div>
                                        </div>
                                    </div>
                                    <uc:TaskComments ShowAddCommentButton="false" Collapsed="false" runat="server" ID="TaskComments" DisableReactions="true"></uc:TaskComments>
                                    
                                    <div class="row">
                                        <div class="col-md-2">
                                            <a class="btn red" href="/dashjs/admin/ViewTemplateReport.aspx?ReportID=<%=this.ReportTemplateID.HasValue ? this.ReportTemplateID.Value.ToString() : "" %>">Cancel</a>
                                            <asp:Button Text="Assign" runat="server" CssClass="btn green" OnClick="Assign_Click"/>
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
