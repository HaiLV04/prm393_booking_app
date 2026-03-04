import 'package:prm393_booking_app/features/customer_menu/data/menu_models.dart';

const menuCategories = [
  MenuCategory(name: 'All', active: true),
  MenuCategory(name: 'Seafood', active: false),
  MenuCategory(name: 'Dessert', active: false),
  MenuCategory(name: 'Drinks', active: false),
  MenuCategory(name: 'Starters', active: false),
  MenuCategory(name: 'Vegan', active: false),
];

const menuDishes = [
  MenuDish(
    title: 'Grilled Salmon',
    description:
        'Fresh atlantic salmon served with grilled asparagus and lemon butter.',
    price: r'$24.00',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuC14sasEGRy1krnzCBAPsj7VaUIPN5Fgy2yD7CMhiassZGAcM1MoIFdCPNUPbAprpHPkMKwc_HY0JElLuvMtiE1vnsL9KgYi3bxLosNYTPARsA2TBA2jS64R3nYelOD0VCYZLlugaFn5hUChC6yCQ2aWBPI8oZtIYJp9OC1AkLH4MdJMGDZK8CY9YBW2hMDZ7DZQxRVR4Wc9O4LWsuEIisD-j18x3TLYa52ejw_zBUxkNp50NAAurtiNZgHgRig5ZhiFNJFxscwNTU',
  ),
  MenuDish(
    title: 'Lava Cake',
    description:
        'Rich molten chocolate center served with vanilla bean ice cream.',
    price: r'$12.00',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCeXHlEBEuQMasNyxul4bM9H2ISe7duMFTi6CVEmY9-yujfjiuHC_bxzUanGFvYWQs4q7MDJ-0NMCRIfMq9An3__rWw1B1xqcr0KJ2mjID8wpmPL4Tt4rF61_mL6YkVQtwhpbZesO9biuSOlYeLm5upnaJpkWCSCGFhX-5nU37Gg7DzoW4QUbURFLosTS2rvVyStXrImvdCpbqsynY8q1_oki5Jg9UcB4EwWM86tNRKO0vMRUvR443IAwCNtu1IuDytlAMwm16TNvE',
  ),
  MenuDish(
    title: 'Classic Mojito',
    description: 'Refreshing mint, white rum, fresh lime juice and soda water.',
    price: r'$10.00',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAx2Jsrmxo6UI0kSBLc_rNOvjgG4XBKoJKbFoUMPL0PtUwaYcMPWFidmx2-wh3_BnfPdzN4ilsIXO3Awz3bR2PYrnrvz9Y8uDroCOlGq0Z22Str97KO0yesC8YPZ8FeBudG_5r9AIJF9K5QEFRqG9dxiY-ct24_QFdS0p2XociLqmegK6I1GYz40prhXeygX9453OBr4k_UkrwHE17JV05XWpG9tzaxej7BYKXVg4RcFJlhYjN6eW9i9xBYnUEfk8R5j0Aqv7H8lQQ',
  ),
  MenuDish(
    title: 'Lobster Bisque',
    description:
        'Creamy seafood soup made with fresh lobster chunks and herbs.',
    price: r'$18.00',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAwYShQm5NWzk9mG4x9YE6gWP7cS9xbfTnUlHhLO2N3VBCn42H70yDyp96WpuJR-zpFYIAQpy3XT6hZ5XQehofhW8FeUdWe_k5cA67seNLPHFP4LCn4eR_021QTJ-dqBsEPLGY9HVTEKoa83FT9u-pqKRBrGdHGTwFYnQ26nW3gR6_sf1UcK9nf0ibJm7BSL7Pilq3Jytp8M7grrT6p51njzHszaj9ME4MZ1R_HRjscg55TNxC8YzHnZmCM9KQ1yDMltABwJ4icdmM',
  ),
  MenuDish(
    title: 'Pepperoni Pizza',
    description:
        'Classic pepperoni with mozzarella and our signature tomato sauce.',
    price: r'$15.00',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAxxXYNPZSX5wenl5fqFeyZnC3XIOQZfpFTmGqedlB8f-fnrZFjrZ-J7SVnGY0H0zH5Y8nDDeZ3zFlzEtb1f2SqpNLD8dSYg_pdwG4GRNWu08FlfEY8frRz5NACADXwjNp090faKnTgLzxls9fYvqVGN1dcXxKoeyLBO328njJZlrY5IDmQr96o0hIRCW-zbWPZAdtJ35rFBswhRD6fhtS6RlJz_cQnQfsCYFcpMZ61SNLf_NHwZKkaYFwYm2KYhEXfAn2PXd6YjvM',
  ),
  MenuDish(
    title: 'Pasta Carbonara',
    description:
        'Spaghetti with pancetta, egg yolk, pecorino cheese and black pepper.',
    price: r'$19.00',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCQP4q8Rg7CjXuDnFBzX5P9SrhpafmPf8jhSHJfSO2fFRaKZAGFFshA7494JVxIu2N_CcKGNiIujzf1a9po5ti1ofbne21TLFhoFtes7e30lokigImCt8v--f4gX-5wkmz2jIwS7qkIwbQdl7i3-2NaHCryN65bKck-sS3Q1o1yoUJTrOUg2BYE7HrcYXtI01V5BqdBRcaBjlWOtt1XphALLw5CrayP7uYVPmuKFltmYN1AyKi8bAz2Ki9OO7F8dviHlFVEi0dpvco',
  ),
];

const popularImage =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCj2-a6DK-rNW_-mqLcZcE3nhiaqithy32juX5KlYxyeW5FOuDk7Zn1-zyH6yfDJHaHRtOpyDRTD25lXLdynGUOxADiC8D3l2TM2DJM2Emv0bv4MXzXGKHryoeqt4UwCseSCQL5gy1UAaV-W_lXLW0EWB7_49x4zyBz4jadJbDn34QbzhatMOBKQjrDQopVOR0albid3lkV0ziboTGY4RCk8XoJStRSsuwDEAKj2odRHrIAwX2P2v9etPMQj9-12my7swwRxJbRfws';
