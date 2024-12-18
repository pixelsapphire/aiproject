package com.pixelsapphire.aiproject;

import CLIPSJNI.Environment;
import CLIPSJNI.PrimitiveValue;

import javax.swing.*;
import java.awt.Container;
import java.awt.FontMetrics;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.BreakIterator;
import java.util.Locale;
import java.util.MissingResourceException;
import java.util.ResourceBundle;

@SuppressWarnings("CallToPrintStackTrace")
public class EngineeringES implements ActionListener {

    private final JLabel displayLabel;
    private final JButton nextButton;
    private final JButton prevButton;
    private final JPanel choicesPanel;
    private final Environment clips;
    private boolean isExecuting = false;
    private Thread executionThread;
    private ButtonGroup choicesButtons;
    private ResourceBundle autoResources;

    public EngineeringES() {
        try {
            autoResources = ResourceBundle.getBundle("EngineeringES", Locale.getDefault());
        } catch (MissingResourceException mre) {
            mre.printStackTrace();
            System.exit(0);
        }

        final JFrame window = new JFrame(autoResources.getString("EngineeringES"));
        window.getContentPane().setLayout(new GridLayout(3, 1));
        window.setSize(350, 200);
        window.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        final JPanel displayPanel = new JPanel();
        displayLabel = new JLabel();
        displayPanel.add(displayLabel);

        choicesPanel = new JPanel();
        choicesButtons = new ButtonGroup();

        final JPanel buttonPanel = new JPanel();

        prevButton = new JButton(autoResources.getString("Prev"));
        prevButton.setActionCommand("Prev");
        buttonPanel.add(prevButton);
        prevButton.addActionListener(this);

        nextButton = new JButton(autoResources.getString("Next"));
        nextButton.setActionCommand("Next");
        buttonPanel.add(nextButton);
        nextButton.addActionListener(this);

        window.getContentPane().add(displayPanel);
        window.getContentPane().add(choicesPanel);
        window.getContentPane().add(buttonPanel);

        clips = new Environment();
        clips.load("engineering_es.clp");
        clips.reset();
        runES();

        window.setVisible(true);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(EngineeringES::new);
    }

    private void nextUIState() throws Exception {

        String evalStr = "(find-all-facts ((?f state-list)) TRUE)";
        final String currentID = clips.eval(evalStr).get(0).getFactSlot("current").toString();
        evalStr = "(find-all-facts ((?f UI-state)) " +
                  "(eq ?f:id " + currentID + "))";
        PrimitiveValue fv = clips.eval(evalStr).get(0);

        if (fv.getFactSlot("state").toString().equals("final")) {
            nextButton.setActionCommand("Restart");
            nextButton.setText(autoResources.getString("Restart"));
            prevButton.setVisible(true);
        } else if (fv.getFactSlot("state").toString().equals("initial")) {
            nextButton.setActionCommand("Next");
            nextButton.setText(autoResources.getString("Next"));
            prevButton.setVisible(false);
        } else {
            nextButton.setActionCommand("Next");
            nextButton.setText(autoResources.getString("Next"));
            prevButton.setVisible(true);
        }

        choicesPanel.removeAll();
        choicesButtons = new ButtonGroup();

        final PrimitiveValue pv = fv.getFactSlot("valid-answers");
        final String selected = fv.getFactSlot("response").toString();

        for (int i = 0; i < pv.size(); i++) {
            PrimitiveValue bv = pv.get(i);
            JRadioButton rButton;

            if (bv.toString().equals(selected)) rButton = new JRadioButton(autoResources.getString(bv.toString()), true);
            else rButton = new JRadioButton(autoResources.getString(bv.toString()), false);

            rButton.setActionCommand(bv.toString());
            if (pv.size() > 1) choicesPanel.add(rButton);
            choicesButtons.add(rButton);
        }

        choicesPanel.repaint();

        final String theText = autoResources.getString(fv.getFactSlot("display").symbolValue());
        wrapLabelText(displayLabel, theText);
        executionThread = null;
        isExecuting = false;
    }

    @Override
    public void actionPerformed(ActionEvent ae) {
        try {
            onActionPerformed(ae);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void onActionPerformed(ActionEvent event) throws Exception {
        if (isExecuting) return;

        String evalStr = "(find-all-facts ((?f state-list)) TRUE)";
        String currentID = clips.eval(evalStr).get(0).getFactSlot("current").toString();

        if (event.getActionCommand().equals("Next")) {
            if (choicesButtons.getButtonCount() == 0) clips.assertString("(next " + currentID + ")");
            else clips.assertString("(next " + currentID + " " + choicesButtons.getSelection().getActionCommand() + ")");
            runES();
        } else if (event.getActionCommand().equals("Restart")) {
            clips.reset();
            runES();
        } else if (event.getActionCommand().equals("Prev")) {
            clips.assertString("(prev " + currentID + ")");
            runES();
        }
    }

    public void runES() {
        isExecuting = true;
        executionThread = new Thread(() -> {
            clips.run();
            SwingUtilities.invokeLater(() -> {
                try {
                    nextUIState();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            });
        });
        executionThread.start();
    }

    private void wrapLabelText(JLabel label, String text) {
        final FontMetrics fm = label.getFontMetrics(label.getFont());
        final Container container = label.getParent();
        final int containerWidth = container.getWidth();
        final int textWidth = SwingUtilities.computeStringWidth(fm, text);
        final int desiredWidth;

        if (textWidth <= containerWidth) desiredWidth = containerWidth;
        else {
            int lines = (textWidth + containerWidth) / containerWidth;
            desiredWidth = textWidth / lines;
        }

        final BreakIterator boundary = BreakIterator.getWordInstance();
        boundary.setText(text);

        final StringBuilder real = new StringBuilder("<html><center>");
        StringBuilder trial = new StringBuilder();

        int start = boundary.first();
        for (int end = boundary.next(); end != BreakIterator.DONE; start = end, end = boundary.next()) {
            final String word = text.substring(start, end);
            trial.append(word);
            int trialWidth = SwingUtilities.computeStringWidth(fm, trial.toString());
            if (trialWidth > containerWidth) {
                trial = new StringBuilder(word);
                real.append("<br>");
                real.append(word);
            } else if (trialWidth > desiredWidth) {
                trial = new StringBuilder();
                real.append(word);
                real.append("<br>");
            } else {
                real.append(word);
            }
        }

        real.append("</html>");
        label.setText(real.toString());
    }
}