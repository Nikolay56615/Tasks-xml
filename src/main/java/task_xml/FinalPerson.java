package task_xml;

import jakarta.xml.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(propOrder = {"firstName", "familyName", "gender", "brothers", "sisters", "sons", "daughters"})
class FinalPerson {

    @XmlAttribute
    @XmlID
    String id;

    String firstName;
    String familyName;
    String gender;

    @XmlAttribute(name = "mother")
    @XmlIDREF
    FinalPerson mother;

    @XmlAttribute(name = "father")
    @XmlIDREF
    FinalPerson father;

    @XmlAttribute(name = "wife")
    @XmlIDREF
    FinalPerson wife;

    @XmlAttribute(name = "husband")
    @XmlIDREF
    FinalPerson husband;

    Brothers brothers;
    Sisters sisters;
    Sons sons;
    Daughters daughters;

    @XmlAccessorType(XmlAccessType.FIELD)
    public static class Brothers {
        @XmlElement(name = "brother")
        @XmlIDREF
        List<FinalPerson> brother = new ArrayList<>();
    }

    @XmlAccessorType(XmlAccessType.FIELD)
    public static class Sisters {
        @XmlElement(name = "sister")
        @XmlIDREF
        List<FinalPerson> sister = new ArrayList<>();
    }

    @XmlAccessorType(XmlAccessType.FIELD)
    public static class Sons {
        @XmlElement(name = "son")
        @XmlIDREF
        List<FinalPerson> son = new ArrayList<>();
    }

    @XmlAccessorType(XmlAccessType.FIELD)
    public static class Daughters {
        @XmlElement(name = "daughter")
        @XmlIDREF
        List<FinalPerson> daughter = new ArrayList<>();
    }
}

