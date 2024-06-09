using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class CustomizeLoader : MonoBehaviour
{
    private void OnEnable()
    {
        SceneManager.LoadScene("CustomizeSoldiers", LoadSceneMode.Single);
    }
}
