public class comments_JSON {
    public Integer postId;
    public Integer id;
    public String name;
    public String body;
    public String email;

public static List<comments_JSON> parseComment(String json) {
    return (List<comments_JSON>) System.JSON.deserialize(json, List<comments_JSON>.class);
}
}