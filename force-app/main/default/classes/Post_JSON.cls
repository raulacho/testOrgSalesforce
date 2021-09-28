public with sharing class Post_JSON {

        public Integer userId;
        public Integer id;
        public String title;
        public String body;


    public static List<Post_JSON> parsePost(String json) {
        return (List<Post_JSON>) System.JSON.deserialize(json, List<Post_JSON>.class);
    }
}