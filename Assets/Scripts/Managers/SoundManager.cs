using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoundManager : MonoBehaviour
{

    public static SoundManager Instance;
    
    private AudioSource _audioSource;

    [Header("UI Sounds")] 
    [SerializeField] private AudioClip buttonClickAudioClip;
    [SerializeField] private AudioClip equipItemAudioClip;

    private void Awake()
    {
        if (Instance != null)
        {
            Debug.LogWarning("[SoundManager] :: There is already a sound Manager");
            Destroy(this.gameObject);
        }
        Instance = this;
    }

    // Start is called before the first frame update
    void Start()
    {
        _audioSource = GetComponent<AudioSource>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void ActivateButtonClickAudioClip()
    {
        _audioSource.PlayOneShot(buttonClickAudioClip);
    } 
    public void ActivateEquipItemAudioClip()
    {
        _audioSource.PlayOneShot(equipItemAudioClip);
    }
    
    
    
}
