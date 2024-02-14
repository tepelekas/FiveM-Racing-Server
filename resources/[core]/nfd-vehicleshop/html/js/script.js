<<<<<<< HEAD
$(document).ready(function () {
  const $vehicleshopContainer = $("#vehicleshop_container");
  const $vehicleSlider = $(".vehicle-slider");
  const $categoryTable = $(".category-table");
  const $loadingSpinner = $(".loading-spinner");
  const resourceName = GetParentResourceName();
  const $colors = [
    "red",
    "blue",
    "green",
    "yellow",
    "orange",
    "purple",
    "pink",
    "brown",
    "cyan",
    "magenta",
    "teal",
    "navy",
    "gray",
    "black",
    "white",
    "silver",
    "gold",
    "lime",
    "olive",
    "maroon",
  ];
  const $colorPicker = $(".color-options");

  let Vehicles = [];
  let inVehicleshop = false;

  window.addEventListener("message", (event) => {
    const { action, vehicles } = event.data;
    if (action === "openVehicleshop") {
      inVehicleshop = true;
      $vehicleshopContainer.show();
      if (inVehicleshop) {
        let selectedVehicle = Vehicles[0];

        $loadingSpinner.show();
        $.post(
          `https://${resourceName}/spawnVehicle`,
          JSON.stringify({
            vehicle: selectedVehicle,
          }),
          (result) => {
            if (result) {
              $loadingSpinner.hide();
            }
          }
        );
      }
    } else if (action === "closeVehicleshop") {
      $vehicleshopContainer.hide();
      inVehicleshop = false;
    }
  });

  $(document).keyup((data) => {
    if (data.key === "Escape" && inVehicleshop) {
      $loadingSpinner.hide();
      $.post(`https://nfd-lobby/openLobby`, JSON.stringify({}));
      $.post(`https://nfd-vehicleshop/closeVehicleshop`, JSON.stringify({}));
      $vehicleshopContainer.hide();
      inVehicleshop = false;
    }
  });

  // Purchase button click event
  $(".purchase-button").click(function () {
    console.log("Purchase button clicked");
  });

  // Test drive button click event
  $(".test-drive-button").click(function () {
    console.log("Test drive button clicked");
  });

  $colors.forEach((color) => {
    const colorOption = document.createElement("div");
    colorOption.classList.add("color-option");
    colorOption.style.backgroundColor = color;
    colorOption.setAttribute("data-color", color);
    colorOption.addEventListener("click", () => {
      $(".color-option").removeClass("active");
      $(colorOption).addClass("active");
      const rgbValue = getRGB(color);
      $.post(
        `https://nfd-vehicleshop/changeColor`,
        JSON.stringify({
          color: rgbValue,
        })
      );
    });
    $colorPicker.append(colorOption);
  });

  function getRGB(color) {
    // Create a temporary element to apply the color
    const tempElement = document.createElement("div");
    tempElement.style.color = color;
    document.body.appendChild(tempElement);
    // Get the computed color style
    const computedColor = window.getComputedStyle(tempElement).color;
    // Extract the RGB components from the computed color
    const match = computedColor.match(/\d+/g);
    // Remove the temporary element
    document.body.removeChild(tempElement);
    // Return the RGB value
    return match
      ? { r: parseInt(match[0]), g: parseInt(match[1]), b: parseInt(match[2]) }
      : null;
  }

  function updateVehicleDetails(vehicle) {
    $("#vehicle-name").text(vehicle.name);
    $("#vehicle-category").html(
      '<span class="details-title">Category: </span><span>' +
        vehicle.category +
        "</span>"
    );
    $("#vehicle-brand").html(
      '<span class="details-title">Brand: </span><span>' +
        vehicle.brand +
        "</span>"
    );
    $("#vehicle-price").html(
      '<span class="details-title">Price: </span><span>$' +
        vehicle.price.toLocaleString() +
        "</span>"
    );
    $("#vehicle-top-speed").html(
      '<span class="details-title">Top Speed: </span><span>200 km/h' + "</span>"
    );
    $("#vehicle-doors").html(
      '<span class="details-title">Doors: </span><span>2 Doors' + "</span>"
    );
  }

  function createThumbnails(filteredVehicles) {
    let $slider = $(".vehicle-slider");
    $slider.empty();

    if (filteredVehicles.length === 0) {
      console.error("No vehicles found for this category");
      return;
    }

    filteredVehicles.forEach((vehicle, index) => {
      let $img = $("<img>", {
        src: `images/${vehicle.hashname}.png`,
        alt: `${vehicle.name}`,
        class: "vehicle-thumbnail",
      }).appendTo($slider);

      $img.on("click", function () {
        updateVehicleDetails(vehicle);
        setActiveThumbnail(index);

        let selectedVehicle = filteredVehicles[index];

        $loadingSpinner.show();
        $.post(
          `https://${resourceName}/spawnVehicle`,
          JSON.stringify({
            vehicle: selectedVehicle,
          }),
          (result) => {
            if (result) {
              $loadingSpinner.hide();
            }
          }
        );
      });
    });
  }

  function setActiveThumbnail(index) {
    $(".vehicle-thumbnail").removeClass("active").css("border-image", ""); // Remove border from all thumbnails
    $(".vehicle-thumbnail").eq(index).addClass("active");

    // Scroll the slider to bring the selected vehicle in the middle of the screen
    let sliderWidth = $vehicleSlider.width();
    let thumbnailWidth = $(".vehicle-thumbnail").eq(index).outerWidth(true);
    let selectedThumbnailPosition = index * thumbnailWidth;
    let scrollPosition =
      selectedThumbnailPosition - (sliderWidth / 2 - thumbnailWidth / 2);

    // Smoothly animate the scrolling
    $vehicleSlider.stop().animate(
      {
        scrollLeft: scrollPosition,
      },
      500
    ); // Adjust the duration as needed
  }

  function bindButtonEvents() {
    $categoryTable.on("click", ".category-btn", function () {
      $(this).addClass("active").siblings().removeClass("active");

      let selectedCategory = $(this).text();
      let filteredVehicles = Vehicles.filter(
        (v) => v.category === selectedCategory
      );
      createThumbnails(filteredVehicles);

      if (filteredVehicles.length > 0) {
        updateVehicleDetails(filteredVehicles[0]);
        setActiveThumbnail(0);
      }
    });
  }

  function populateCategories() {
    let categories = [...new Set(Vehicles.map((v) => v.category))];
    let categoryButtonsContainer = $(".category-table");
    categoryButtonsContainer.empty();

    categories.forEach((category) => {
      let button = $("<button>", {
        text: category,
        class: "category-btn",
      }).appendTo(categoryButtonsContainer);
    });

    $(".category-table .category-btn:first").click();
  }

  $.post(`https://${resourceName}/getVehicles`, JSON.stringify({})).done(
    function (response) {
      Vehicles = response;
      bindButtonEvents();
      populateCategories();
    }
  );
});
=======
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
>>>>>>> origin/beta
