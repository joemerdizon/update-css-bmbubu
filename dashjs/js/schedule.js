var editEventContainer;
var eventClickData;

$(document).ready(function () {
    var calendarSelection = $('.calendar-selection'),
        selectedInput = $('#SelectedDay'),
        actualMonth,
        schedulerView = $('#SchedulerView');

    $('.scheduler_green_tree_image_expand').trigger('click');
    $('.scheduler_green_tree_image_expand').trigger('click');

    calendarSelection.datepicker({}).on('changeDate', function (e) {
        var monthSelected = moment(e.date).format('MM');
        selectedInput.val(moment(e.date).format('MM/DD/YYYY'));
        if (monthSelected != actualMonth || schedulerView.val() != "Month") {
            doPostBack();
        };
    });

    $('.cal-prev').on('click', function () {
        calendarSelection.datepicker('setDate', moment(selectedInput.val(), 'MM/DD/YYYY', true).add('days', -1)._d);
    });

    $('.cal-next').on('click', function () {
        calendarSelection.datepicker('setDate', moment(selectedInput.val(), 'MM/DD/YYYY', true).add('days', 1)._d);
    });

    $('.cal-today').on('click', function () {
        calendarSelection.datepicker('setDate', moment()._d);
    });

    $('.tabs-container').tab();

    if (selectedInput.val() != '') {
        calendarSelection.datepicker('update', moment(selectedInput.val(), 'MM/DD/YYYY', true)._d);
    };

    actualMonth = moment(calendarSelection.datepicker('getDate')).format('MM');

    $('input.scheduler-view[value="' + schedulerView.val() + '"]').addClass('active');

    $('input.scheduler-view').on('click', function () {
        schedulerView.val($(this).val());
        doPostBack();
    });

    var createNewEventContainer = $('#create-modal');
    editEventContainer = $('#edit-modal');

    $('.create-btn').on('click', function () {
        var actualDate = moment(calendarSelection.datepicker('getDate'));
        createNewEventContainer.find('.startTime-input').val(actualDate.format('HH:mm A')).trigger('blur.timepicker');
        createNewEventContainer.find('.startDate-input').val(actualDate.format('MM/DD/YYYY')).datepicker('update').trigger('change');
        createNewEventContainer.modal('show');
    });

    $('#callout-btn').on('click', function () {
        $('#callout-modal').modal('show');
    });

    initializeCalendarEventForm(createNewEventContainer);
    initializeCalendarEventForm(editEventContainer);
    initializeCalendarEventForm($('#callout-modal'));

    initializeSchedulerColors($('form'));

    $('.submit-event').on('click', function () {
        var container, action, msj, msjContainer, postEventAction,
            successMsg = $('#showSuccessMsg');
        if (createNewEventContainer.is(':visible')) {
            container = createNewEventContainer;
            action = "AddScheduleItem";
            msj = "The schedule item has been created successfully";
            msjContainer = container.find('.event-created-msg');
        }
        else {
            container = editEventContainer;
            action = "EditScheduleItem";
            msj = "The schedule item has been modified successfully";
            msjContainer = $('.edit-success-msj');
        };
        successMsg.val('');

        container.find('#edit-success-msj, .event-created-msg, .event-error-msg').hide();
        container.find('.startTime-input, .endDate-input, .endTime-input').removeAttr('disabled');

        $.ajax({
            type: "POST",
            url: "../ManageUPWebService.asmx/" + action,
            data: serializeArrayToJSON(container.find('.form-horizontal').find(':input').serializeArray()),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            beforeSend: function () {
                container.find('.modal-body').isLoading();
            },
            success: function (data) {
                container.find('.modal-body').isLoading("hide");
                if (data.d.Success) {
                    successMsg.val(msj);
                    doPostBack();
                } else {
                    var errorMsg = '<ul>';
                    $.each(data.d.Errors, function (i, el) {
                        errorMsg += '<li>' + el + '</li>';
                    });

                    errorMsg += '</ul>';
                    container.find('.event-error-msg').html(errorMsg).show('fast');
                    setTimeout(function () {
                        container.find('.event-error-msg').hide('fast');
                    }, 7000);

                    if (container.find('.startTime-input').hasClass('disabled')) {
                        container.find('.startTime-input, .endDate-input, .endTime-input').addAttr('disabled');
                    };
                };
            }
        });

        return false;
    });

    $('.username-val').val($('#UserName').val());

    var msg = $('#showSuccessMsg');
    if (msg.val() != "") {
        $('.success-msg').text(msg.val()).show('fast');
        setTimeout(function () {
            $('.success-msg').hide('fast');
            msg.val('');
        }, 5000);
    };

    var editResourceStatus = $('#edit-resource-status');

    $('#DayPilotScheduler').on('click', '.resource-status', function () {
        var resource = $(this),
            color = resource.css('color');

        editResourceStatus.modal('show');
        editResourceStatus.find('h2 span.resource-name').text(resource.data('resource'));

        $.ajax({
            type: "POST",
            url: "../ManageUPWebService.asmx/GetResource",
            data: "{ resourceId: " + resource.data('id') + "}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            beforeSend: function () {
                editResourceStatus.find('.modal-body').isLoading();
            },
            success: function (data) {
                editResourceStatus.find('.modal-body').isLoading("hide");
                editResourceStatus.find('.current-status span.circle').css('color', color);
                editResourceStatus.find('.current-status span.content').text(data.d.StatusDescription);
                editResourceStatus.find('.resource-id').val(resource.data('id'));

                var statusesOptions = '';

                $.each(data.d.AvailableStatuses, function (i, el) {
                    statusesOptions += "<option value='" + el.Item1 + "' >" + el.Item2 + "</option> \r\n";
                });

                editResourceStatus.find('select.available-status').html(statusesOptions).val(data.d.ResourceAvailabityStatusID);
            }
        });
    });

    $('.save-callout').on('click', function () {
        var container = $('#callout-modal');
        $.ajax({
            type: "POST",
            url: "../ManageUPWebService.asmx/AddCallout",
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
                    $('.success-msg').text('Request was submitted and is awaiting approval. You will be notified when your request is approved.').show('fast');
                    setTimeout(function () {
                        $('.success-msg').hide('fast');
                    }, 7000);
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

    var scheduleItemActions = $('#schudule-item-actions');

    scheduleItemActions.find('#edit-schedule-item').on('click', editEventClick);
    scheduleItemActions.find('#show-schedule-item-users').on('click', function () {
        var item = $('#item-' + eventClickData.data.id);
        var container = $('#show-user-preferences');

        container.find('h2').text(eventClickData.data.text);
        container.find('#main-user').text(item.data('username'));
        container.find('#main-user-pane').text('user id: ' + item.data('user'));

        if (isNaN(item.data('coveruser'))) {
            container.find('#cover-user').hide();
        }
        else {
            container.find('#cover-user').text(item.data('coverusername')).show();
            container.find('#cover-user-pane').text('user id: ' + item.data('coveruser'));
        };

        container.modal('show');
        container.find('#main-user').tab('show');
    });

    $('.submit-resource-status').on('click', function () {
        $.ajax({
            type: "POST",
            url: "../ManageUPWebService.asmx/ChangeResourceStatus",
            data: "{ resourceId: " + editResourceStatus.find('.resource-id').val() + ", status: " + editResourceStatus.find('select.available-status').val() + "}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            beforeSend: function () {
                editResourceStatus.find('.modal-body').isLoading();
            },
            success: function (data) {
                editResourceStatus.find('.modal-body').isLoading("hide");

                if (data.d.Success) {
                    $('#showSuccessMsg').val("The status was changed successfully");
                    doPostBack();
                } else {
                    var errorMsg = '<ul>';
                    $.each(data.d.Errors, function (i, el) {
                        errorMsg += '<li>' + el + '</li>';
                    });

                    errorMsg += '</ul>';
                    editResourceStatus.find('.error-msg').html(errorMsg).show('fast');
                    setTimeout(function () {
                        editResourceStatus.find('.error-msg').hide('fast');
                    }, 7000);
                };
            },
            error: function () {
                editResourceStatus.find('.modal-body').isLoading("hide");
            }
        });
    });
});

var initializeSchedulerColors = function (container) {
    var baseBackground = '';
    if (navigator.userAgent.match(/Chrome/)) {
        baseBackground = '-webkit';
    } else if (navigator.userAgent.match(/Firefox/) || navigator.userAgent.match(/AppleWebKit/)) {
        baseBackground = '-moz';
    } else if (navigator.userAgent.match(/MSIE/) || navigator.userAgent.match(/Trident/)) {
        baseBackground = '-ms';
    } else if (navigator.userAgent.match(/Opera/)) {
        baseBackground = '-o';
    };

    $.each(container.find('.input-schedule-item-data'), function (index, el) {
        var colorFrom = $(el).data('colorfrom'),
            colorTo = $(el).data('colorto'),
            background = baseBackground + '-linear-gradient(top, ' + colorFrom + ' 0%, ' + colorTo + ')',
            scheduleItem = $('.schedule-item-' + $(el).data('itemid')).find('.scheduler_green_event_inner');

        if (colorFrom.length > 6 && colorTo.length > 6){
            scheduleItem.css('background', background);
            scheduleItem.css('border-color', colorFrom);
        };
    });
};

var eventClick = function (e) {
    eventClickData = e;
    $('#schudule-item-actions').find('h2').text(e.data.text);
    $('#schudule-item-actions').modal('show');
};

var editEventClick = function () {
    e = eventClickData;
    resetForm(editEventContainer);
    editEventContainer.modal('show');
    var startTime = moment(e.data.start);
    var endTime = moment(e.data.end);

    editEventContainer.find('.name-input').val(e.data.text).trigger('change');

    console.log(e.data.id);
    var userval = $('#item-' + e.data.id).data('user');
    editEventContainer.find('#username').val(userval);

    editEventContainer.find('#resource').val(e.data.resource).trigger('change');
    editEventContainer.find('.schedule-item-id-input').val(e.data.id).trigger('change');

    editEventContainer.find('h2').text('Edit schedule item: ' + e.data.text);

    editEventContainer.find('.endDate-input').val(endTime.format('MM/DD/YYYY')).datepicker('update').trigger('change');
    editEventContainer.find('.endTime-input').val(endTime.format('HH:mm A')).trigger('blur.timepicker');
    editEventContainer.find('.startTime-input').val(startTime.format('HH:mm A')).trigger('blur.timepicker');
    editEventContainer.find('.startDate-input').val(startTime.format('MM/DD/YYYY')).datepicker('update');
    editEventContainer.find('.endDate-input').trigger('change');
};

var doPostBack = function () {
    $('.modal').modal('hide');
    $('form').isLoading();
    $('form').submit();
};