var jstree, preventSelectingChilds, preventDrawingTheTree = 0, sections = [], selectedDueDates = {};

$(document).ready(function () {

    if ($('#errorsMsjs').val() != '') {
        showErrorMsgs($('div.page-content'), $('#errorsMsjs').val().split(';'));
    };

    showSuccessMsj();

    loadTempalteTasks();
    loadFooter();
    reloadSavedFooters();
    initializeFooterModal();

    $('#DocItems').on('ready.jstree', function () {
        preventSelectingChilds = true;

        var sectionsContainer = $('.sections');
        if (sections.length == 1 && sections[0].Name == "default") {
            $('#default-section-container').append($('#only-default-section').tmpl(sections[0]));
            $('#accordion-container').hide();
        };

        $.each(sections, function (i, el) {
            var taskList = [];

            if (el.TemplateTaskList != undefined) {
                $.each(el.TemplateTaskList, function (i, selectedTask) {
                    taskList.push(selectedTask.TemplateTaskID);
                    //selectedDueDates[selectedTask.TemplateTaskID] = selectedTask;
                });

                el.TemplateTaskList = JSON.stringify(el.TemplateTaskList);
            };

            sectionsContainer.append($('#section-content').tmpl(el));
            drawSelectedTasks(taskList, sectionsContainer.find('.section-container:last'));
        });

        sectionsContainer.sortable({ axis: "y", stop: function () { orderSections(); }, delay: 150 });
        sectionsContainer.find('.report-data, .report-data .childTaskContet').sortable({ axis: "y", stop: function () { orderTasks(); }, delay: 150 });

        $('#SaveAndAssignButton, #SaveReportButton, #saveAndAssign-btn').removeAttr('disabled');
        $('#CloneButton').removeAttr('disabled');
        preventSelectingChilds = false;

        var to = false;
        $('#template-search').keyup(function () {
            if (to) { clearTimeout(to); };
            to = setTimeout(function () {
                var v = $('#template-search').val();
                jstree.search(v);
            }, 250);
        });

        $('.sections').on('show.bs.collapse', '.portlet-body', function () {
            var sectionContainer = $(this).closest('li');

            var currentCollapseButton = $(this).siblings('.portlet-title').find('.collapse');

            $('.sections .collapse').not(currentCollapseButton).trigger('click');

            jstree.uncheck_all();
            jstree.close_all();

            sectionContainer.addClass('selected');

            var sectionTaskSelected = getSelectedTaskList($(this).closest('.section-container'));

            preventSelectingChilds = true;

            $.each(sectionTaskSelected, function (i, el) {
                var nodeData = jstree.get_node(el.TemplateTaskID);
                if (nodeData.parents != undefined && nodeData.parents.length > 0) {
                    $.each(nodeData.parents, function (index, parent) {
                        jstree.open_node(parent);
                    });
                };

                jstree.check_node(el.TemplateTaskID);
            });

            preventSelectingChilds = false;
            orderTasks();
        });
        $('.sections').on('hide.bs.collapse', '.portlet-body', function () {
            var sectionContainer = $(this).closest('li');

            jstree.uncheck_all();
            jstree.close_all();
            sectionContainer.removeClass('selected');
        });

        orderSections();
        orderTasks();
    });

    $('select').select2();
    $('div.calender input.calender').datepicker({ todayHighlight: true, startDate: new Date() });


    $('#add-section').on('click', function () {
        initializeSectionModal();
        $('#add-section-modal').modal('show');
        return false;
    });

    $('#customize-footer').on('click', function () {
        var reportFooterModal = $('#customize-footer-modal');

        var footer = $("#ReportTemplateFooter").val();
        reportFooterModal.find('textarea[name="footer-html"]').summernote('code', footer);

        var showAssessmentActions = $("#ShowAssessmentActions").val() == "true";
        $('#show-assessment-actions').prop('checked', showAssessmentActions);
        $.uniform.update();

        reportFooterModal.modal({
            backdrop: 'static',
            keyboard: false
        });
        return false;
    });
    
    $('#add-to-saved-footers').on('click', function () {
        bootbox.prompt("Choose a name", function (result) {
            if (result !== null) {
                if (result.trim() != "") {
                    var reportFooterModal = $('#customize-footer-modal');
                    var footerHTML = reportFooterModal.find('textarea[name="footer-html"]').summernote('code');
                    var url = '/dashjs/admin/createreportdoc.aspx/AddSavedFooter';
                    var data = JSON.stringify({ footerName: result, footerHTML: footerHTML });
                    var callbackSuccess = function () {
                        bootbox.alert("The footer was saved successfully");
                        reloadSavedFooters();
                    };
                    var callbackError = function () {
                        bootbox.alert("Oops! There was a problem!");
                    };
                    call(url, data, callbackSuccess, callbackError);
                } else {
                    bootbox.alert("Please enter a valid name", function () {
                        $('#add-to-saved-footers').trigger('click');
                    });
                }
            }
        });
    });

    $('#load-saved-footer').on('click', function () {
        var loadSavedFooterModal = $('#load-saved-footer-modal');
        loadSavedFooterModal.find('textarea[name="saved-footer-html"]').summernote('disable');
        loadSavedFooterModal.modal({
            backdrop: 'static',
            keyboard: false
        });
    });

    $('#edit-saved-footer').on('click', function () {
        enterSavedFooterEditionMode();
        
    });

    $("#SavedReportFooters").on('change', function () {
        var loadSavedFooterModal = $('#load-saved-footer-modal');

        if (this.value == 0) {
            loadSavedFooterModal.find('textarea[name="saved-footer-html"]').summernote('code', '');

            $('#edit-saved-footer').prop("disabled", true);
            $('#delete-saved-footer').prop("disabled", true);
            $('#saved-footer-load').prop("disabled", true);

            return false;
        }

        callWebService({
            url: "/dashjs/admin/createreportdoc.aspx/GetSavedFooter",
            data: JSON.stringify({ savedReportTemplateFooterID: this.value }),
            success: function (footer) {
                footer = footer.d;
                loadSavedFooterModal.find('textarea[name="saved-footer-html"]').summernote('code', footer.FooterHTML);

                $('#edit-saved-footer').prop("disabled", false);
                $('#delete-saved-footer').prop("disabled", false);
                $('#saved-footer-load').prop("disabled", false);
            },
            blockTarget: loadSavedFooterModal
        });
    });

    $('#saved-footer-load').on('click', function () {
        var reportFooterModal = $('#customize-footer-modal');
        var loadSavedFooterModal = $('#load-saved-footer-modal');

        footer = loadSavedFooterModal.find('textarea[name="saved-footer-html"]').summernote('code');
        reportFooterModal.find('textarea[name="footer-html"]').summernote('code', footer);

        loadSavedFooterModal.modal('hide');
    });

    $('#saved-footer-save-changes').on('click', function () {
        var savedReportTemplateFooterID = $('#SavedReportFooters').val();
        var loadSavedFooterModal = $('#load-saved-footer-modal');
        var footerHTML = loadSavedFooterModal.find('textarea[name="saved-footer-html"]').summernote('code');

        callWebService({
            url: "/dashjs/admin/createreportdoc.aspx/EditSavedFooter",
            data: JSON.stringify({ savedReportTemplateFooterID: savedReportTemplateFooterID, footerHTML: footerHTML }),
            success: function () {
                bootbox.alert("The footer was saved successfully");
                exitSavedFooterEditionMode();
            },
            error: function(){
                bootbox.alert("Oops! There was a problem!");
            },
            blockTarget: loadSavedFooterModal
        });
    });

    $('#saved-footer-cancel-changes').on('click', function () {
        bootbox.confirm("Are you sure you want to discard the changes?", function (result) {
            if (result) {
                $("#SavedReportFooters").trigger('change');
                exitSavedFooterEditionMode();
            }
        })
    });

    $('#delete-saved-footer').on('click', function () {
        bootbox.confirm("Are you sure you want to delete the footer?", function (result) {
            if (result) {
                var savedReportTemplateFooterID = $('#SavedReportFooters').val();
                var loadSavedFooterModal = $('#load-saved-footer-modal');

                callWebService({
                    url: "/dashjs/admin/createreportdoc.aspx/DeleteSavedFooter",
                    data: JSON.stringify({ savedReportTemplateFooterID: savedReportTemplateFooterID }),
                    success: function () {
                        bootbox.alert("The footer was deleted successfully");
                        reloadSavedFooters();
                        $("#SavedReportFooters").trigger('change');
                    },
                    error: function () {
                        bootbox.alert("Oops! There was a problem!");
                    },
                    blockTarget: loadSavedFooterModal
                });

            }
        })
    });

    $('#add-section-save').on('click', function () {
        var sectionModal = $('#add-section-modal'),
            sectionID = sectionModal.data('sectionid'),
            name = sectionModal.find('input[name="name"]').val(),
            description = sectionModal.find('textarea[name="description"]').summernote('code');

        if ($('.default-section-container').is(':visible')) {
            sectionID = $('li.section-container:first').data('sectionid');
        };

        if (validateSectionModal(sectionID, name, sectionModal)) {
            $('#accordion-container').show();
            $('.default-section-container').remove();

            if (sectionID == '') {
                var newID = String(Math.random()).replace('.', '');
                $('.sections').append($('#section-content').tmpl({
                    SectionID: newID,
                    Name: name,
                    Description: description,
                    TemplateTaskList: "[]"
                }));

                showSection(newID);
                orderSections();
            }
            else {
                var sectionContainer = $('#section-container-' + sectionID);

                sectionContainer.find('.name-value').val(name);
                sectionContainer.find('.description-value').val(description);

                sectionContainer.find('.name-head').text(name);
                sectionContainer.find('.description-head').html(description);

                showSection(sectionID);
            };

            sectionModal.modal('hide');
        };
    });

    $('#customize-footer-save').on('click', function () {
        var footerModal = $('#customize-footer-modal'),
            description = footerModal.find('textarea[name="footer-html"]').summernote('code');

        $('#report-template-footer').html(description);
        $('#ReportTemplateFooter').val(description);

        var showAssessmentActions = $('#show-assessment-actions').prop('checked');
        if (showAssessmentActions) {
            $('#assessment-actions').show();
        } else {
            $('#assessment-actions').hide();
        }

        $('#ShowAssessmentActions').val(showAssessmentActions);

        footerModal.modal('hide');
    });

    $('.section-and-task-column').on('click', '.delete-section', function () {
        var sectionid = $(this).closest('.section-container').data('sectionid');
        $('#confirm-delete-modal').data('sectionid', sectionid).modal('show');
        return false;
    });

    $('.section-and-task-column').on('click', '.remove-task', function () {
        var taskid = $(this).data('taskid'),
            deleteTaskModal = $('#confirm-delete-task-modal'),
            type = $(this).data('type');

        deleteTaskModal.data('type', type);
        deleteTaskModal.data('taskid', taskid).modal('show');
        deleteTaskModal.find('h3 span').text('"' + $(this).data('taskname') + '"');

        return false;
    });

    $('.section-and-task-column').on('click', '.edit-section', function () {
        var sectionContainer = $(this).closest('.section-container'),
            sectionid = sectionContainer.data('sectionid'),
            sectionModal = $('#add-section-modal');

        initializeSectionModal(sectionid, sectionContainer.find('.name-value').val(), sectionContainer.find('.description-value').val());

        sectionModal.modal('show');

        return false;
    });

    var iframe = $('.add-task-report iframe');

    var showIframeSlide = function () {
        $('.report-container').toggle('slide', { direction: 'right' });
        $('.add-task-report').toggle('slide', { direction: 'left' });

        Metronic.blockUI({ target: '.add-task-report' });
    };

    iframe.load(function () {
        iframe.show();
        autoResizeIframeContent(iframe[0]);
        Metronic.unblockUI('.add-task-report');
    });

    var favCheck = $('#Favorite');
    $('#add-as-fav').on('click', function () {
        if ($(this).hasClass('red')) {
            favCheck.removeAttr('checked');
            $(this).removeClass('red');
        }
        else {
            favCheck.prop('checked', true);
            $(this).addClass('red');
        };
    });

    if (favCheck.is(':checked')) {
        $('#add-as-fav').trigger('click');
    };

    $('.section-and-task-column').on('click', '#add-task, a.edit-task', function () {
        var src = iframe.data('src');
        if ($(this).data('taskid') != undefined) {
            src = src + '&TemplateTaskID=' + $(this).data('taskid');
        };

        iframe.attr('src', src);

        showIframeSlide();
    });

    $('#SaveReportButton').on('click', function () {
        orderTasks();
        ShowWorkingModal();
    });

    $(".references-title").click(function () {
        $(".references-container").stop().slideToggle();
        $(".references-title i").toggleClass("fa-caret-down fa-caret-up")
    });

    //Adds tootltip to jstree items that were truncated
    $(document).on('mouseenter', '.jstree-container-ul a', function () {
        var $this = $(this);

        if (this.offsetWidth < this.scrollWidth && !$this.attr('title')) {
            $this.attr('title', $this.text());
        }
    });
});

var loadTempalteTasks = function (taskAdded) {
    $.ajax({
        type: "POST",
        url: "../../ManageUPWebService.asmx/GetAllTemplateTasksForJsTree",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: {},
        beforeSend: function () {
            try {
                jstree.destroy();
            }
            catch (e) {
            }

            Metronic.blockUI({ target: '#main-row-with-jstree-and-sections' });
            $('.section-and-task-column').css("visibility", "hidden");

            $('#DocItems').html('');
        },
        success: function (data) {
            Metronic.unblockUI('#main-row-with-jstree-and-sections');
            $('#DocItems').on('check_node.jstree', function (event, selected) {
                if ($('.section-container.selected').length == 0) {
                    showErrorMsgs($('div.page-content'), ['You should select a section first.']);
                    jstree.uncheck_node(selected.node.id);
                    return;
                };

                preventDrawingTheTree++;
                if (!preventSelectingChilds) {
                    $.each(selected.node.children, function (i, el) {
                        jstree.check_node(el);
                    });
                };

                jstree.open_node(selected.node.id);

                var nodeType = selected.node.original.data_type;

                preventSelectingChilds++;
                jstree.check_node(selected.node.parents);
                preventSelectingChilds--;

                preventDrawingTheTree--;
                drawSelectedTasks(selected.selected, $('.section-container.selected'));
            }).on('uncheck_node.jstree', function (event, selected) {
                preventDrawingTheTree++;
                jstree.uncheck_node(selected.node.children);
                preventDrawingTheTree--;

                drawSelectedTasks(selected.selected, $('.section-container.selected'));
            }).on('ready.jstree', function () {
                $('.section-and-task-column').css("visibility", "");
                if (taskAdded != undefined) {
                    var selectedSection = $('.section-container.selected');

                    var selectedTasks = getSelectedTaskList(selectedSection);

                    if (!inArrayWithCondition(selectedTasks, function (el) { return el.TemplateTaskID == taskAdded })) {
                        selectedTasks.push({ TemplateTaskID: taskAdded });
                    }

                    selectedSection.find('.sectionTaskSelected').val(JSON.stringify(selectedTasks));

                    showSection(selectedSection.data('sectionid'));
                };
            });

            jstree = $.jstree.create($('#DocItems'), {
                'core': {
                    data: data.d,
                    'themes': {
                        'responsive': false
                    }
                },
                "types": {
                    "parent": {
                        "icon": "fa fa-pencil-square icon-lg"
                    },
                    "child": {
                        "icon": "fa fa-pencil-square-o icon-lg"
                    }
                },
                "plugins": ["checkbox", "search", "types", "wholerow"],
                "checkbox": { "three_state": false, "tie_selection": false, "keep_selected_style": false },
                "search": { "show_only_matches": true }
            });
        }
    });
};

var loadFooter = function () {
    var showAssessmentActions = $("#ShowAssessmentActions").val() == "true";
    $('#show-assessment-actions').prop('checked', showAssessmentActions);
    $.uniform.update();

    if (showAssessmentActions) {
        $('#assessment-actions').show();
    } else {
        $('#assessment-actions').hide();
    }

    var footer = $("#ReportTemplateFooter").val();
    $("#report-template-footer").html(footer);
}

var getSelectedTaskList = function (sectionContainer) {
    return JSON.parse(sectionContainer.find('.sectionTaskSelected').val());
};

var showSection = function (sectionID) {
    var sectionContainer = $('#section-container-' + sectionID);
    if (sectionContainer.hasClass('selected') || sectionContainer.find('.portlet-body').is(':visible')) {
        sectionContainer.find('.portlet-body').trigger('show.bs.collapse');
    }
    else if (sectionContainer.find('.expand').length == 0) {
        sectionContainer.find('.collapse').trigger('click');
        sectionContainer.find('.expand').trigger('click');
    }
    else {
        sectionContainer.find('.expand').trigger('click');
    };

    drawSelectedTasks(getSelectedTaskList(sectionContainer).map(function (el) { return el.TemplateTaskID }), sectionContainer);
};

var validateSectionModal = function (sectionID, name, sectionModal) {
    if (name != '') {
        var duplicatedName = false;
        $('.section-container input.name-value').each(function (i, el) {
            if ($(el).val().toLowerCase().trim() == name.toLowerCase().trim() && $(el).closest('.section-container').data('sectionid') != sectionID) {
                duplicatedName = true;
                return false;
            };
        });

        if (duplicatedName) {
            showErrorMsgs(sectionModal, ["There is already another section with the same 'Name'."]);
            return false;
        };
    }
    else if (sectionModal.find('textarea[name="description"]').summernote('code','')) {
        showErrorMsgs(sectionModal, ["The 'Name' or the 'Description' is required."]);
        return false;
    };

    return true;
};

var getChildAndParentsFromTaskList = function (taskIdList, parentNodes, childNodes) {
    $.each(taskIdList, function (i, el) {
        var nodeData = jstree.get_node(el);
        if (nodeData.original.data_type == 'task') {
            parentNodes.push(nodeData);
        }
        else {
            childNodes.push(nodeData);
        };
    });
}

var drawSelectedTasks = function (taskIdList, container) {
    var parentNodes = [],
        childNodes = [],
        selectedTasksContainer = container.find('.report-data'),
        sectionTaskSelected = [];

    taskIdList = removeCategoriesAndSubcategoriesFromTaskList(taskIdList);

    if ($('.default-section-container').is(':visible')) {
        selectedTasksContainer = $('.default-section-container');
    };

    if (!preventDrawingTheTree) {
        selectedTasksContainer.html('');
        getChildAndParentsFromTaskList(taskIdList, parentNodes, childNodes);
        $.each(taskIdList, function (i, el) {
            sectionTaskSelected.push({ TemplateTaskID: el });
        });

        var parentNodesIds = [];

        $.each(parentNodes, function (i, el) {
            parentNodesIds.push(el.id);
            selectedTasksContainer.append($('#selected-task-tmpl').tmpl(el));
        });

        $.each(childNodes, function (i, el) {
            if (parentNodesIds.indexOf(el.parent) > -1) {
                $('.templateTask-' + el.parent).find('.childTaskContet').append($('#child-task-section').tmpl(el));
            }
            else {
                selectedTasksContainer.append($('#selected-task-tmpl').tmpl(el));
            };
        });

        container.find('.sectionTaskSelected').val(JSON.stringify(sectionTaskSelected));
        container.find('.report-data, .report-data .childTaskContet').sortable({ axis: "y", stop: function () { orderTasks(); }, delay: 150 });
    };
};

var loadSections = function (sectionsToLoad) {
    sections = sectionsToLoad;
};

var orderSections = function () {
    $('.section-container').each(function (i, el) {
        $(el).find('.section-order').val(i);
    });

    if ($('.section-container').length == 0) {
        jstree.uncheck_all();
        jstree.close_all();
        return;
    };

    if ($('.section-container').length == 1 || $('.section-container.selected').length == 0) {
        showSection($('.section-container:first').data('sectionid'));
    };
};

var orderTasks = function () {
    $('.section-container').each(function (i, el) {

        var tasksOrder = {};
        $(el).find('li.selected-task, span.selected-task').each(function (index, selectedTask) {
            tasksOrder[$(selectedTask).data('id')] = index;
        });

        var selectedTaskList = getSelectedTaskList($(el));

        $.each(selectedTaskList, function (ind, task) {
            task.Order = tasksOrder[task.TemplateTaskID];
        });

        $(el).find('.sectionTaskSelected').val(JSON.stringify(selectedTaskList));
    });
};

var removeSection = function () {
    var sectionID = $('#confirm-delete-modal').data('sectionid');
    $('#section-container-' + sectionID).remove();
    orderSections();
    $('#confirm-delete-modal').modal('hide');
    return;
};

var removeTask = function () {
    var modal = $('#confirm-delete-task-modal'),
        taskId = modal.data('taskid'),
        type = modal.data("type"),
        selectedSection = $('.section-container.selected');

    var selectedTasks = getSelectedTaskList(selectedSection);

    //If the task to remove is a parent task, we remove its action items as well
    if (type == 'parent-task') {
        var actionItems = jstree.get_node(taskId).children;

        $.each(actionItems, function (index, actionItemID) {
            removeFromArrayWithCondition(selectedTasks, function (el) { return el.TemplateTaskID == actionItemID });
        });
    }

    selectedTasks = removeFromArrayWithCondition(selectedTasks, function (el) { return el.TemplateTaskID == taskId });
    selectedSection.find('.sectionTaskSelected').val(JSON.stringify(selectedTasks));
    showSection(selectedSection.data('sectionid'));

    modal.modal('hide');
    return;
};

var initializeSectionModal = function (sectionID, name, description) {
    if (sectionID == undefined) {
        sectionID = name = description = '';
    };

    var sectionModal = $('#add-section-modal');

    sectionModal.data('sectionid', sectionID).modal('show');

    sectionModal.find('input[name="name"]').val(name);
    sectionModal.find('textarea[name="description"]').summernote('code', description);
};

var closeAddTaskIframeAndAddTask = function (templateTaskID) {
    if (templateTaskID != undefined) {
        loadTempalteTasks(templateTaskID);
    };

    $('.report-container').toggle('slide', { direction: 'right' });
    $('.add-task-report').toggle('slide', { direction: 'left' });
};

var enterSavedFooterEditionMode = function () {
    var loadSavedFooterModal = $('#load-saved-footer-modal');
    loadSavedFooterModal.find('textarea[name="saved-footer-html"]').summernote('enable');

    $('#saved-footer-save-changes').show();
    $('#saved-footer-cancel-changes').show();
    $('#edit-saved-footer').prop("disabled", true);
    $('#delete-saved-footer').prop("disabled", true);
    $('#saved-footer-load').prop("disabled", true);
    $('#saved-footer-cancel').prop("disabled", true);
    $('#SavedReportFooters').prop("disabled", true);
};


var exitSavedFooterEditionMode = function () {
    var loadSavedFooterModal = $('#load-saved-footer-modal');
    loadSavedFooterModal.find('textarea[name="saved-footer-html"]').summernote('disable');

    $('#saved-footer-save-changes').hide();
    $('#saved-footer-cancel-changes').hide();
    $('#edit-saved-footer').prop("disabled", false);
    $('#delete-saved-footer').prop("disabled", false);
    $('#saved-footer-load').prop("disabled", false);
    $('#saved-footer-cancel').prop("disabled", false);
    $('#SavedReportFooters').prop("disabled", false);
};

var reloadSavedFooters = function () {
    var savedReportFootersSelect = $("#SavedReportFooters");

    savedReportFootersSelect.empty();
    savedReportFootersSelect.append($('<option>', {
        value: '0',
        text: 'Select'
    }));
    savedReportFootersSelect.val("0").trigger("change");

    callWebService({
        url: "/dashjs/admin/createreportdoc.aspx/GetSavedFooters",
        success: function (footers) {
            footers = footers.d;
            $.each(footers, function (index, footer) {
                savedReportFootersSelect.append($('<option>', {
                    value: footer.SavedReportTemplateFooterID,
                    text: footer.Name
                }));
            });
        },
        blockTarget: $('#load-saved-footer-modal')
    });
};

var initializeFooterModal = function () {
    $('#edit-saved-footer').prop("disabled", true);
    $('#delete-saved-footer').prop("disabled", true);
    $('#saved-footer-load').prop("disabled", true);
}

var removeCategoriesAndSubcategoriesFromTaskList = function (list) {
    return $.grep(list, function (nodeID) {
        var nodeData = jstree.get_node(nodeID);
        return nodeData.original.data_type != 'category' && nodeData.original.data_type != 'sub-category';
    });
}