package com.jobtracker.util;

import com.jobtracker.model.Application;
import com.jobtracker.model.User;

import java.util.ArrayList;
import java.util.List;

public final class PlacementScoreEngine {

    private PlacementScoreEngine() {
    }

    public static int calculateScore(User user, List<Application> applications) {
        if (user == null) {
            return 0;
        }

        double score = 0.0;
        double cgpa = user.getCgpa() == null ? 0.0 : user.getCgpa();
        score += Math.min((cgpa / 10.0) * 25.0, 25.0);

        int skillsCount = countCommaSeparatedItems(user.getSkills());
        score += Math.min(skillsCount, 10) * 2.0;

        int projectsCount = countCommaSeparatedItems(user.getProjects());
        score += Math.min(projectsCount, 5) * 3.0;

        int experienceYears = extractExperienceYears(user.getExperience());
        score += Math.min(experienceYears, 3) * 3.33;

        int interviewCount = 0;
        int offerCount = 0;
        if (applications != null) {
            for (Application application : applications) {
                if (application == null || application.getStatus() == null) {
                    continue;
                }
                if ("Interview".equalsIgnoreCase(application.getStatus())) {
                    interviewCount++;
                }
                if ("Offer".equalsIgnoreCase(application.getStatus())) {
                    offerCount++;
                }
            }
        }

        score += Math.min(interviewCount, 10) * 1.5;
        score += Math.min(offerCount, 3) * 5.0;

        if (score < 0) {
            return 0;
        }
        if (score > 100) {
            return 100;
        }
        return (int) Math.round(score);
    }

    public static List<String> getSuggestions(User user, List<Application> applications) {
        List<String> suggestions = new ArrayList<>();
        if (user == null) {
            suggestions.add("Complete your profile details to receive placement readiness insights.");
            return suggestions;
        }

        double cgpa = user.getCgpa() == null ? 0.0 : user.getCgpa();
        if (cgpa < 7.5) {
            suggestions.add("Focus on improving academic consistency to stay eligible for more campus drives.");
        }

        if (countCommaSeparatedItems(user.getSkills()) < 5) {
            suggestions.add("Add more technical skills aligned with your target roles, especially core Java and SQL.");
        }

        if (countCommaSeparatedItems(user.getProjects()) < 2) {
            suggestions.add("Build at least two strong resume-ready projects that demonstrate end-to-end problem solving.");
        }

        if (extractExperienceYears(user.getExperience()) < 1) {
            suggestions.add("Seek internships, freelance work, or practical experience to strengthen your profile.");
        }

        int interviewCount = 0;
        int offerCount = 0;
        if (applications != null) {
            for (Application application : applications) {
                if (application == null || application.getStatus() == null) {
                    continue;
                }
                if ("Interview".equalsIgnoreCase(application.getStatus())) {
                    interviewCount++;
                }
                if ("Offer".equalsIgnoreCase(application.getStatus())) {
                    offerCount++;
                }
            }
        }

        if (interviewCount < 2) {
            suggestions.add("Apply to more relevant roles and refine your resume to increase interview conversion.");
        }

        if (offerCount == 0) {
            suggestions.add("Practice mock interviews regularly to improve your chances of converting interviews into offers.");
        }

        if (suggestions.isEmpty()) {
            suggestions.add("Your placement readiness looks strong. Keep applying consistently and preparing for interviews.");
        }

        return suggestions;
    }

    private static int countCommaSeparatedItems(String value) {
        if (value == null || value.trim().isEmpty()) {
            return 0;
        }

        String[] parts = value.split(",");
        int count = 0;
        for (String part : parts) {
            if (!part.trim().isEmpty()) {
                count++;
            }
        }
        return count;
    }

    private static int extractExperienceYears(String experience) {
        if (experience == null || experience.trim().isEmpty()) {
            return 0;
        }

        String normalized = experience.toLowerCase();
        StringBuilder numberBuilder = new StringBuilder();
        for (int i = 0; i < normalized.length(); i++) {
            char currentChar = normalized.charAt(i);
            if ((currentChar >= '0' && currentChar <= '9') || currentChar == '.') {
                numberBuilder.append(currentChar);
            } else if (numberBuilder.length() > 0) {
                break;
            }
        }

        if (numberBuilder.length() == 0) {
            return 0;
        }

        try {
            double parsedYears = Double.parseDouble(numberBuilder.toString());
            return (int) Math.floor(parsedYears);
        } catch (NumberFormatException exception) {
            return 0;
        }
    }
}
