let Vehicles = []
let inVehicleshop = false;
const scrollSpeed = 30;
let isScrolling = false;
let scrollInterval;

$(document).ready(function () {
    window.addEventListener('message', function (event) {
        switch (event.data.action) {
            case 'openVehicleshop':
                inVehicleshop = true
                Vehicles = event.data.vehicles;
                initVehicleSelection();
                $('#vehicleshop_container').show();
                break;
            case 'closeVehicleshop':
                $('#vehicleshop_container').hide();
                break;
        }
    })

    $(document).keyup(function (data) {
        if (data.key === 'Escape' && inVehicleshop) {
            $.post('https://nfd-lobby/openLobby', JSON.stringify());
            $('#vehicleshop_container').hide();
        }
    });

    $('.vehicle-slider').on('mouseenter', function () {

        $(this).on('mousemove', function (e) {
            let isInEdge = e.clientX < 50 || e.clientX > $(this).width() - 50;

            if (isInEdge) {
                if (e.clientX < 50) {
                    startScrolling('left', $(this));
                }
                else if (e.clientX > $(this).width() - 50) {
                    startScrolling('right', $(this));
                }
            } else {
                stopScrolling(); 
            }
        });

        $(this).on('mouseleave', function () {
            stopScrolling();
        });

    });
});

function startScrolling(direction, element) {
    if (!isScrolling) {
        isScrolling = true;

        scrollInterval = setInterval(function () {
            if (direction == 'left') {
                element.scrollLeft(element.scrollLeft() - scrollSpeed);
            } else {
                element.scrollLeft(element.scrollLeft() + scrollSpeed);
            }
        }, 100);
    }
}

function stopScrolling() {
    isScrolling = false;
    clearInterval(scrollInterval);
}

function updateVehicleDetails(vehicle) {
    $('#vehicle-name').text(vehicle.name);
    $('#vehicle-category').html('<span class="details-title">Category:</span> <span>' + vehicle.category + '</span>');
    $('#vehicle-brand').text('Brand: ' + vehicle.brand);
    $('#vehicle-price').text('Price: $' + vehicle.price.toLocaleString());
    $('#vehicle-top-speed').text('Top Speed: 200 km/h');
    $('#vehicle-doors').text('Doors: 2 Doors');
}

function createThumbnails() {
    $.each(Vehicles, function (index, vehicle) {
        let $img = $('<img>', { src: `images/${vehicle.hashname}.png`, alt: vehicle.name, class: 'vehicle-thumbnail' });
        $img.click(function () {
            updateVehicleDetails(vehicle);
            setActiveThumbnail(index);
        });
        $('.vehicle-slider').append($img);
    });
}

function setActiveThumbnail(index) {
    $('.vehicle-thumbnail').removeClass('active').eq(index).addClass('active');
}

function initVehicleSelection() {
    createThumbnails();
    setActiveThumbnail(0);
    updateVehicleDetails(Vehicles[0]);
}