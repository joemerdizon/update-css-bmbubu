$(document).ready(function () {
    var container = $('#repeatSchedule-container'),
        lastOption = $('#TaskOptions').find('input:last');

    lastOption.on('change', function () {
        if ($(this).is(':checked')) {
            container.closest('tr').show();
        }
        else {
            container.closest('tr').hide();
            resetForm(container);
        };
    });

    initializeCalendarEventForm(container);
    var repeatOptions = $('.repeat-pattern-set-value').val();

    if (repeatOptions == '') {
        container.scheduler();
    }
    else {
        container.scheduler('setValue', { repeatOptions: repeatOptions } );
    }

    lastOption.trigger('change');

});