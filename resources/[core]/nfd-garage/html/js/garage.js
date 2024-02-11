let inGarage = false

$(document).ready(function () {
    window.addEventListener('message', function (event) {
        switch (event.data.action) {
            case 'openGarage':
                $('#garage_container').show();
                inGarage = true
                if (event.data.invoker ==='resource') {
                    $('#fix-car').hide();
                } else {
                    $('#fix-car').show();
                }
                break;
            case 'closeGarage':
                $('#garage_container').hide();
                break;
        }
    });

    $(document).keyup(function (data) {
        if (data.key === 'Escape' && inGarage) {
            $.post('https://nfd-lobby/openLobby', JSON.stringify());
            $('#garage_container').hide();
        }
    });
});