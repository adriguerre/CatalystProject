using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class MenuManager : MonoBehaviour
{
    public static MenuManager Instance;
    
    [Header("Timeline")]
    [SerializeField] private PlayableDirector timelineToLoadCustomizeSoldier;
    [SerializeField] private GameObject fadeScreen;
    [Header("MainMenu")]
    [SerializeField] private GameObject mainMenuGameObject;
    
    [Header("Missions")]
    [SerializeField] private GameObject missionsGameObject;
    [SerializeField] private Button missionsButton;
    [Header("Options")]
    [SerializeField] private GameObject optionGameObject;
    [SerializeField] private Button optionsButton;
    [Header("Quit")]
    [SerializeField] private Button quitButton;
    [Header("Back From Missions")]
    [SerializeField] private Button goBackButton;
    [Header("Customize Soldier")]
    [SerializeField] private Button customizeButton;

    [Header("Scenes To Load")] 
    [SerializeField] private string levelScene = "TrainingLevel";
    [SerializeField] private string customizingSoldierScene = "CustomizeSoldier";

    [Header("Loading Screen")] 
    [SerializeField] private GameObject loadingScreen;
    [SerializeField] private Image loadingBar;
    
    private List<AsyncOperation> _sceneToLoad = new List<AsyncOperation>();

    [Header("Customize Soldier Camera")] 
    [SerializeField] private GameObject customizeCamera;
    [Header("Main Menu Camera")] 
    [SerializeField] private GameObject mainMenuCamera;

    private void Awake()
    {
        if (Instance != null)
        {
            Debug.LogWarning("[MenuManager] :: There is already a menu Manager");
        }

        Instance = this; 
    }

    // Start is called before the first frame update
    void Start()
    {
        
        missionsGameObject.SetActive(false);
        optionGameObject.SetActive(false);
        mainMenuGameObject.SetActive(true);
        loadingScreen.SetActive(false);
        
        customizeButton.onClick.AddListener(() => LoadCustomizeScene());
        optionsButton.onClick.AddListener(() => GoFromMenuToOptions());
        missionsButton.onClick.AddListener(() => GoFromMenuToMissions());
        goBackButton.onClick.AddListener(() => GoFromMissionToMenu());
        quitButton.onClick.AddListener(() => QuitGame());
        
        _sceneToLoad.Add(SceneManager.LoadSceneAsync(customizingSoldierScene, LoadSceneMode.Additive));
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void LoadCustomizeScene()
    {    
        //We Load Scene from Timeline
       // fadeScreen.SetActive(true);
       // timelineToLoadCustomizeSoldier.Play();
       SoundManager.Instance.ActivateButtonClickAudioClip();
       mainMenuGameObject.SetActive(false);
       mainMenuCamera.SetActive(false);
       //_sceneToLoad.Add(SceneManager.LoadSceneAsync(customizingSoldierScene, LoadSceneMode.Additive));
    }

    public void ReturnFromCustomize()
    {
        SoundManager.Instance.ActivateButtonClickAudioClip();
        mainMenuGameObject.SetActive(true);
        mainMenuCamera.SetActive(true);
    }
    
    private void GoFromMenuToMissions()
    {
        SoundManager.Instance.ActivateButtonClickAudioClip();
        mainMenuGameObject.SetActive(false);
        missionsGameObject.SetActive(true);
    }
    private void GoFromMissionToMenu()
    {
        SoundManager.Instance.ActivateButtonClickAudioClip();
        mainMenuGameObject.SetActive(true);
        missionsGameObject.SetActive(false);
    }

    private void GoFromMenuToOptions()
    {
       /*mainMenuGameObject.SetActive(false);
        optionGameObject.SetActive(true);
        */
       SoundManager.Instance.ActivateButtonClickAudioClip();
       Manager.Instance.SetGameStatu(GameStatus.Playing);
       _sceneToLoad.Add(SceneManager.LoadSceneAsync(levelScene));
       loadingScreen.SetActive(true);
       //StartCoroutine(ProgressLoadingBar());
    }

    private void QuitGame()
    {
        SoundManager.Instance.ActivateButtonClickAudioClip();
        Application.Quit();
    }

    private IEnumerator ProgressLoadingBar()
    {
        float loadProgress = 0f;
        for (int i = 0; i < _sceneToLoad.Count; i++)
        {
            while (!_sceneToLoad[i].isDone)
            {
                loadProgress += _sceneToLoad[i].progress;
                loadingBar.fillAmount = loadProgress / _sceneToLoad.Count;
                yield return null;
            }
        }
    }



    
}
