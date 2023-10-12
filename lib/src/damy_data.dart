/* 

User: 
1- userUiD
2- Name
3- Bio
4- username
5- Email
6- Password
7- profile picture 
8- birthday 

Post:
1- text
2- image (optional)
3- uid, 
4- userUiD
5- createDate

 */


/* UserModel myUser = UserModel(
  uid: "1",
  avatarUrl:
      "https://media.sketchfab.com/models/624acae4597c40eb90aebc2650bc99bf/thumbnails/09e3261cc6204116b5fc611acb4eda6d/f4957ec96b79488298ec52c245986898.jpeg",
  bio: "Flutter app developer",
  birthday: Timestamp.fromDate(DateTime(1997, 3, 30)),
  email: "info@salaropr)o.con",
  name: "Salar Khalid",
  username: "salarpro",
);
 */
/* List<PostModel> get myPosts => [
      PostModel(
        uid: "1",
        userUid: "1",
        text: "My post",
        imageUrl:
            "https://www.highlandsco.com/wp-content/uploads/2015/03/highlands-model-wheel-e1481547764800.jpg",
        comments: [
          CommentModel(
            uid: "1",
            comment: "My comment",
            userUid: "2",
            createdAt: Timestamp.fromDate(DateTime(2023, 8, 25, 5, 25)),
          ),
          CommentModel(
            uid: "1",
            comment: "My comment",
            userUid: "2",
            createdAt: Timestamp.fromDate(DateTime(2023, 8, 25, 5, 25)),
          ),
        ],
        // likesUserUID: null,
        createdAt: Timestamp.fromDate(DateTime(2023, 8, 25, 5, 25)),
        updateAt: Timestamp.fromDate(DateTime(2023, 8, 25, 5, 25)),
      ),
      PostModel(
        uid: "2",
        userUid: "1",
        text:
            "My post My post My post My post My post My post My post My post My post My post My post ",
        imageUrl: null,
        comments: [
          CommentModel(
            uid: "1",
            comment: "My comment",
            userUid: "2",
            createdAt: Timestamp.fromDate(DateTime(2023, 8, 25, 5, 25)),
          ),
          CommentModel(
            uid: "1",
            comment: "My comment",
            userUid: "2",
            createdAt: Timestamp.fromDate(DateTime(2023, 8, 25, 5, 25)),
          ),
          CommentModel(
            uid: "1",
            comment: "My comment",
            userUid: "2",
            createdAt: Timestamp.fromDate(DateTime(2023, 8, 25, 5, 25)),
          ),
          CommentModel(
            uid: "1",
            comment: "My comment",
            userUid: "2",
            createdAt: Timestamp.fromDate(DateTime(2023, 8, 25, 5, 25)),
          ),
        ],
        likesUserUID: [
          "11",
          "22",
          "110",
          "11",
          "22",
          "110",
          "11",
          "112",
          "2210",
          "111",
          "112",
          "2210",
          "111",
          "112",
          "1011"
        ],
        createdAt: Timestamp.fromDate(DateTime(2023, 8, 25, 5, 25)),
        updateAt: Timestamp.fromDate(DateTime(2023, 8, 25, 5, 25)),
      ),
      PostModel(
        uid: "2",
        userUid: "1",
        text:
            "My post My post My post My post My post My post My post My post My post My post My post ",
        imageUrl:
            "https://www.highlandsco.com/wp-content/uploads/2015/03/highlands-model-wheel-e1481547764800.jpg",
        comments: [
          CommentModel(
            uid: "1",
            comment: "My comment",
            userUid: "2",
            createdAt: Timestamp.fromDate(DateTime(2023, 8, 25, 5, 25)),
          ),
        ],
        likesUserUID: ["11", "2210"],
        createdAt: Timestamp.fromDate(DateTime(2023, 8, 25, 5, 25)),
        updateAt: Timestamp.fromDate(DateTime(2023, 8, 25, 5, 25)),
      ),
      PostModel(
        uid: "2",
        userUid: "1",
        text:
            "My post My post My post My post My post My post My post My post My post My post My post ",
        imageUrl:
            "https://www.highlandsco.com/wp-content/uploads/2015/03/highlands-model-wheel-e1481547764800.jpg",
        comments: [
          CommentModel(
            uid: "1",
            comment: "My comment",
            userUid: "2",
            createdAt: Timestamp.fromDate(DateTime(2023, 8, 25, 5, 25)),
          ),
        ],
        likesUserUID: [
          "11",
        ],
        createdAt: Timestamp.fromDate(DateTime(2023, 8, 25, 5, 25)),
        updateAt: Timestamp.fromDate(DateTime(2023, 8, 25, 5, 25)),
      ),
      PostModel(
        uid: "2",
        userUid: "1",
        text:
            "My post My post My post My post My post My post My post My post My post My post My post ",
        imageUrl:
            "https://www.highlandsco.com/wp-content/uploads/2015/03/highlands-model-wheel-e1481547764800.jpg",
        comments: [
          CommentModel(
            uid: "1",
            comment: "My comment",
            userUid: "2",
            createdAt: Timestamp.fromDate(DateTime(2023, 8, 25, 5, 25)),
          ),
        ],
        likesUserUID: [],
        createdAt: Timestamp.fromDate(DateTime(2023, 8, 25, 5, 25)),
        updateAt: Timestamp.fromDate(DateTime(2023, 8, 25, 5, 25)),
      ),
    ]; */

/* 
List<Map<String, dynamic>> posts = [
  {
    "uid": "1",
    "userUiD": "1",
    "text": "Hello",
    "image":
        "https://www.highlandsco.com/wp-content/uploads/2015/03/highlands-model-wheel-e1481547764800.jpg",
    "createDate": Timestamp.fromDate(DateTime(2023, 8, 25, 5, 25)),
    "likesCount": [
      "1",
      "2",
      "2",
      "2",
      "2",
      "3",
    ],
    "comments": [
      {"userUiD": "1", "comment": "Nice"},
      {"userUiD": "1", "comment": "GOOD WORK"},
      {"userUiD": "1", "comment": "Good"},
    ]
  },
  {
    "uid": "2",
    "userUiD": "1",
    "text": "Hello",
    "image": null,
    "createDate": Timestamp.fromDate(DateTime(2023, 8, 25, 5, 25)),
    "likesCount": [
      "1",
      "2",
      "3",
      "1",
      "2",
      "3",
      "1",
      "2",
      "3",
    ],
    "comments": [
      {"userUiD": "1", "comment": "Nice"},
      {"userUiD": "1", "comment": "GOOD WORK"},
      {"userUiD": "1", "comment": "Good"},
      {"userUiD": "1", "comment": "GOOD WORK"},
      {"userUiD": "1", "comment": "Good"},
    ]
  },
  {
    "uid": "3",
    "userUiD": "1",
    "text": "Hello",
    "image":
        "https://www.highlandsco.com/wp-content/uploads/2015/03/highlands-model-wheel-e1481547764800.jpg",
    "createDate": Timestamp.fromDate(DateTime(2023, 8, 25, 5, 25)),
    "likesCount": [
      "1",
      "2",
      "3",
      "1",
      "2",
      "3",
      "1",
      "2",
      "3",
      "1",
      "2",
      "3",
    ],
    "comments": [
      {
        "userUiD": "1",
      },
    ]
  },
];
 */
