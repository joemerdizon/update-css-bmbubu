<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterNewUI.Master" CodeBehind="ViewTemplateReport.aspx.cs" Inherits="ManageUPPRM.dashjs.admin.ViewTemplateReport" %>

<%@ Import Namespace="ManageUPPRM.Extensions" %>
<%@ Register TagPrefix="uc" TagName="UsersGroupModal" Src="~/UserControls/UsersGroupModal.ascx" %>

<asp:Content ContentPlaceHolderID="head" ID="head" runat="server">
    <script src="<%= Page.ContentLastWrite("/dashjs/js/fuelUx/scheduler.js")%>"></script>
    <script type="text/javascript">
        var loadSections = function (sections) {
            $.each(sections, function (i, el) {
                var taskList = [];
                $('ul.sections').append($('#section-content').tmpl(el));
                var parentNodes = [], childNodes = [], selectedTasksContainer = $('.section-container:last .report-data');
                if (el.TemplateTaskList != undefined) {
                    $.each(el.TemplateTaskList, function (i, templateTask) {
                        if (isNaN(templateTask.ParentID) || templateTask.ParentID == null) {
                            parentNodes.push(templateTask);
                        }
                        else {
                            childNodes.push(templateTask);
                        };
                    });
                };

                var parentNodesIds = [];
                $.each(parentNodes, function (i, parentNode) {
                    parentNodesIds.push(parentNode.TemplateTaskID);
                    selectedTasksContainer.append($('#selected-task-tmpl').tmpl(parentNode));
                });

                $.each(childNodes, function (i, childNode) {
                    if (parentNodesIds.indexOf(childNode.ParentID) > -1) {
                        $('.templateTask-' + childNode.ParentID).find('.childTaskContet').append($('#child-task-section').tmpl(childNode));
                    }
                    else {
                        selectedTasksContainer.append($('#selected-task-tmpl').tmpl(childNode));
                    };
                });
            });
        };

        var showAssignModal = function () {
            var assignTasksModal = $('#AssignTemplateTask'),
                sectionsContainer = assignTasksModal.find('.report-assignment');

            sectionsContainer.html('<ul></ul>');

            $('.sections .section-container').each(function (i, section) {
                sectionsContainer.find('ul:first').append($('#section-content-assignment-tmpl').tmpl({ Name: $(section).data('name'), Description: $(section).data('description') }));
                var selectedTasksContainer = sectionsContainer.find('ul:first li:last .report-data');

                $(section).find('.parent-task').each(function (i, parentTask) {
                    selectedTasksContainer.append($('#parent-template-task-assignment-tmpl').tmpl({ text: $(parentTask).data('name'), id: $(parentTask).data('id') }));
                    var parentTaskContainer = selectedTasksContainer.find('> li:last');
                    //TODO: If the action items are displayed, we need to validate the dates
                    $(parentTask).find('.child-task').each(function (i, childTask) {
                        parentTaskContainer.find('.childTaskContet').append($('#child-template-task-assignment-tmpl').tmpl({ text: $(childTask).data('name'), id: $(childTask).data('id') }));
                    });
                });
            });

            assignTasksModal.find('.report-assignment input').datepicker({ todayHighlight: true, startDate: new Date() });
            assignTasksModal.modal('show');

            return false;
        };

        var loadFooter = function () {
            var footer = $("#<%=ReportTemplateFooter.ClientID%>").val();
            $("#report-template-footer").html(footer);

            var showAssessmentActions = $("#<%=ShowAssessmentActions.ClientID%>").val() == "true";
            if (showAssessmentActions) {
                $('#assessment-actions').show();
            } else {
                $('#assessment-actions').hide();
            }
        }

        $(document).ready(function () {
            $('select').select2();
            loadFooter();
        });
    </script>

    <style>
        
        /* signature information */
        p.signature-acknowledge {
            font-weight: bold;
            font-style: italic;
            margin-bottom: 0px;
        }

        .signature-wrapper {
            padding-top: 18px;
        }

        .signature-wrapper label {
            background-color: #fff;
            padding-right: 8px;
        }
        .signature-line {
            height: 15px;
            border-bottom: 1px solid #949594;
        }
        .report-template-footer {
            overflow:auto;
            margin-bottom: 20px;
            margin-top: 20px;
        }

        .note-editor .signature-container {
            overflow:auto;
            border-width: 1px; 
            border-style: dashed; 
            border-color: gray;
            cursor: not-allowed;
        }

        .note-editor .signature-label {
            cursor: not-allowed;
        }
    </style>
</asp:Content>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="ContentPlaceHolder1" runat="server">
    <div class="page-content-wrapper">
        <div class="page-content">
            <h3 class="page-title">View Template Report:&nbsp;<span runat="server" id="ReportName"></span>
            </h3>

            <div class="page-bar">
                <ul class="page-breadcrumb">
                    <li class="ms-hover">
                        <i class="fa fa-home"></i>
                        <a href="/dashjs/dashboardjsnew.aspx">Dashboard</a>
                        <i class="fa fa-angle-right"></i>
                    </li>
                    <li class="ms-hover">
                        <a href="reportDocuments.aspx">Reports</a>
                        <i class="fa fa-angle-right"></i>
                    </li>
                    <li class="ms-hover">
                        <a href="#">View</a>
                    </li>
                </ul>
            </div>
            <div class="row">
                <div class="col-md-12" id="msg-container"></div>
            </div>
            <div class="row playbook">
                <div class="col-md-12">
                    <div class="portlet box">

                        <div class="portlet-title">
                            <div class="caption">
                                TEMPLATE SECTIONS
                            </div>
                            <div class="actions">
                                <a runat="server" id="Clone" visible="true" class="btn blue">Clone</a>
                                <a runat="server" id="Assign" visible="false" class="btn green">Assign</a>
                                <a runat="server" id="EditReport" class="btn green">
                                    <i class="fa fa-pencil"></i>
                                    Edit
                                </a>
                            </div>
                            <div class="gray-liner"></div>
                        </div>

                        <div class="portlet-body">
                            <div id="accordion-container">
                                <div class="template-section">
                                    <ul class="sections"></ul>
                                </div>
                            </div>
                            <asp:HiddenField ID="ShowAssessmentActions" runat="server"/>
                            <div class="top-liner" id="assessment-actions">
                                <div class="margin-top-15">
                                    <div class="col-sm-3">
                                        <label class="control-label">Action resulting from assessment:</label>
                                    </div>
                                    <div class="col-sm-8 margin-bottom-15">
                                        <div class="checkbox-list">
                                            <label class="checkbox-inline"><input class="md-check" type="checkbox" disabled="disabled" /> Promotion</label>
                                            <label class="checkbox-inline"><input class="md-check" type="checkbox" disabled="disabled" /> Demotion</label>
                                            <label class="checkbox-inline"><input class="md-check" type="checkbox" disabled="disabled" /> Maintained</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="light-liner"></div>
                            <div id="report-template-footer" class="report-template-footer"></div>
                            <asp:HiddenField ID="ReportTemplateFooter" runat="server"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/x-jquery-tmpl" id="section-content">
        <li data-sectionid="${SectionID}" data-name="${Name}" data-description="${Description}" id="section-container-${SectionID}" class="section-container">
            <div class="portlet box">
                <div class="portlet-title">
                    <div class="pull-left tools">
                        <a href="javascript:;" class="collapse"></a>
                    </div>
                    <div class="caption margin-top-10">
                        <span class="name-head">{{html Name}}</span>
                        <span class="description-head">{{html Description}}</span>
                    </div>
                    <div class="tools text-right">
                    </div>
                </div>
                <div class="portlet-body" id="section-content-${SectionID}">
                    <ul class="report-data">
                    </ul>
                </div>
            </div>
        </li>
    </script>
    <script type="text/x-jquery-tmpl" id="selected-task-tmpl">
        <li class="templateTask-${TemplateTaskID} parent-task" data-name="${Name}" data-id="${TemplateTaskID}">
            <span class="marT10 selected-task" data-id="${TemplateTaskID}"><a href="../viewdtask.aspx?templateTaskID=${TemplateTaskID}">${Name}</a></span>
            <a href="../viewdtask.aspx?templateTaskID=${TemplateTaskID}&contentonly=" data-name="${Name}" data-tabid="${TemplateTaskID}" class="fa fa-eye open-full-screen-modal pull-right"></a>
            <ul class="childTaskContet">
            </ul>
        </li>
    </script>
    <script type="text/x-jquery-tmpl" id="child-task-section">
        <li class="selected-task child-task" data-name="${Name}" data-id="${TemplateTaskID}">${Name}
        </li>
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="modals" ID="modals" runat="server">
    <uc:UsersGroupModal ID="UsersGroupModal" runat="server" />
</asp:Content>
