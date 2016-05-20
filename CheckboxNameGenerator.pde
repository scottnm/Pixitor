static class CheckboxNameGenerator {
    static int id = 0;
    static String getNextId() {
        return new Integer(id++).toString();
    }
}
